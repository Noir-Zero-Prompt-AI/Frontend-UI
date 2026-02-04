import AppKit
import Carbon.HIToolbox

class HotkeyManager {
    static let shared = HotkeyManager()
    
    private var controlSpaceHandler: EventHotKeyRef?
    private var optionSpaceHandler: EventHotKeyRef?
    private var commandBackslashHandler: EventHotKeyRef?
    
    private var controlSpaceID = EventHotKeyID(signature: OSType(0x484F4C4D), id: 1)
    private var optionSpaceID = EventHotKeyID(signature: OSType(0x484F4C4D), id: 2)
    private var commandBackslashID = EventHotKeyID(signature: OSType(0x484F4C4D), id: 3)
    
    var onControlSpace: (() -> Void)?
    var onOptionSpace: (() -> Void)?
    var onCommandBackslash: (() -> Void)?
    
    private init() {}
    
    func registerHotkeys() {
        registerControlSpace()
        registerOptionSpace()
        registerCommandBackslash()
        installEventHandler()
    }
    
    func unregisterHotkeys() {
        if let handler = controlSpaceHandler {
            UnregisterEventHotKey(handler)
        }
        if let handler = optionSpaceHandler {
            UnregisterEventHotKey(handler)
        }
        if let handler = commandBackslashHandler {
            UnregisterEventHotKey(handler)
        }
    }
    
    private func registerControlSpace() {
        let modifier = UInt32(Carbon.controlKey)
        let keyCode = UInt32(kVK_Space)
        
        RegisterEventHotKey(
            keyCode,
            modifier,
            controlSpaceID,
            GetApplicationEventTarget(),
            0,
            &controlSpaceHandler
        )
    }
    
    private func registerOptionSpace() {
        let modifier = UInt32(Carbon.optionKey)
        let keyCode = UInt32(kVK_Space)
        
        RegisterEventHotKey(
            keyCode,
            modifier,
            optionSpaceID,
            GetApplicationEventTarget(),
            0,
            &optionSpaceHandler
        )
    }
    
    private func registerCommandBackslash() {
        let modifier = UInt32(Carbon.cmdKey)
        let keyCode = UInt32(kVK_ANSI_Backslash)
        
        RegisterEventHotKey(
            keyCode,
            modifier,
            commandBackslashID,
            GetApplicationEventTarget(),
            0,
            &commandBackslashHandler
        )
    }
    
    private func installEventHandler() {
        var eventSpec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        
        InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, event, _) -> OSStatus in
                var hotKeyID = EventHotKeyID()
                GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                
                DispatchQueue.main.async {
                    switch hotKeyID.id {
                    case 1:
                        HotkeyManager.shared.onControlSpace?()
                    case 2:
                        HotkeyManager.shared.onOptionSpace?()
                    case 3:
                        HotkeyManager.shared.onCommandBackslash?()
                    default:
                        break
                    }
                }
                
                return noErr
            },
            1,
            &eventSpec,
            nil,
            nil
        )
    }
}

class LocalHotkeyManager {
    static let shared = LocalHotkeyManager()
    
    private var monitors: [Any] = []
    
    var onControlSpace: (() -> Void)?
    var onOptionSpace: (() -> Void)?
    var onCommandBackslash: (() -> Void)?
    
    private init() {}
    
    func start() {
        let globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        
        let localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
        
        if let global = globalMonitor {
            monitors.append(global)
        }
        if let local = localMonitor {
            monitors.append(local)
        }
    }
    
    func stop() {
        monitors.forEach { NSEvent.removeMonitor($0) }
        monitors.removeAll()
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        
        // Space key = 49
        if event.keyCode == 49 {
            if flags == .control {
                onControlSpace?()
            } else if flags == .option {
                onOptionSpace?()
            }
        }
        
        // Backslash key = 42
        if event.keyCode == 42 && flags == .command {
            onCommandBackslash?()
        }
    }
}
