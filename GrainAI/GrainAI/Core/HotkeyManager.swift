import Foundation
import AppKit
import Carbon

@Observable
class HotkeyManager {
    @ObservationIgnored private var eventTap: CFMachPort?
    @ObservationIgnored private var runLoopSource: CFRunLoopSource?
    @ObservationIgnored private var globalMonitor: Any?
    @ObservationIgnored private var localMonitor: Any?
    
    func setup() {
        setupGlobalEventTap()
        setupNSEventMonitors() // Add backup method
    }
    
    private func setupGlobalEventTap() {
        // Create event tap for global hotkeys (works even when app not focused)
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                return HotkeyManager.handleGlobalEvent(proxy: proxy, type: type, event: event, refcon: refcon)
            },
            userInfo: nil
        ) else {
            print("❌ Failed to create event tap - need Accessibility permissions")
            return
        }
        
        self.eventTap = eventTap
        
        // Create run loop source and add to current run loop
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        
        // Enable the event tap
        CGEvent.tapEnable(tap: eventTap, enable: true)
        print("✅ Global hotkey manager initialized")
    }
    
    private static func handleGlobalEvent(
        proxy: CGEventTapProxy,
        type: CGEventType,
        event: CGEvent,
        refcon: UnsafeMutableRawPointer?
    ) -> Unmanaged<CGEvent>? {
        
        guard type == .keyDown else {
            return Unmanaged.passRetained(event)
        }
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let flags = event.flags
        
        // Control + Space (keyCode 49)
        if flags.contains(.maskControl) && keyCode == 49 {
            print("🔵 Control+Space detected")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .openSearchBar, object: nil)
            }
            return nil // Consume event
        }
        
        // Option + Space (keyCode 49) - Show/hide desktop icon
        if flags.contains(.maskAlternate) && keyCode == 49 {
            print("🟢 Option+Space detected - showing desktop assistant")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .toggleSideIcon, object: nil)
            }
            return nil // Consume event
        }
        
        // ESC key (keyCode 53)
        if keyCode == 53 {
            print("🔴 ESC detected")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .hideSearchBar, object: nil)
            }
        }
        
        return Unmanaged.passRetained(event)
    }
    
    // BACKUP METHOD: NSEvent monitors (simpler, more reliable)
    private func setupNSEventMonitors() {
        print("🔧 Setting up NSEvent monitors as backup")
        
        // Global monitor (works when app is not active)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            self.handleNSEvent(event)
        }
        
        // Local monitor (works when app is active)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            self.handleNSEvent(event)
            return event
        }
        
        print("✅ NSEvent monitors initialized")
    }
    
    private func handleNSEvent(_ event: NSEvent) {
        let keyCode = event.keyCode
        let flags = event.modifierFlags
        
        // Control + Space
        if flags.contains(.control) && keyCode == 49 {
            print("🔵 NSEvent: Control+Space detected")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .openSearchBar, object: nil)
            }
        }
        
        // Option + Space
        if flags.contains(.option) && keyCode == 49 {
            print("🟢 NSEvent: Option+Space detected")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .toggleSideIcon, object: nil)
            }
        }
        
        // ESC
        if keyCode == 53 {
            print("🔴 NSEvent: ESC detected")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .hideSearchBar, object: nil)
            }
        }
    }
    
    func cleanup() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
    }
    
    deinit {
        cleanup()
    }
}
