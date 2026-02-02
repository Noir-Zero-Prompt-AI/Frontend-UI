import Foundation
import AppKit
import Carbon

@Observable
class HotkeyManager {
    @ObservationIgnored private var eventTap: CFMachPort?
    @ObservationIgnored private var runLoopSource: CFRunLoopSource?
    
    func setup() {
        setupGlobalEventTap()
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
            print("Failed to create event tap - need Accessibility permissions")
            return
        }
        
        self.eventTap = eventTap
        
        // Create run loop source and add to current run loop
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        
        // Enable the event tap
        CGEvent.tapEnable(tap: eventTap, enable: true)
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
            Task { @MainActor in
                NotificationCenter.default.post(name: .openSearchBar, object: nil)
            }
            return nil // Consume event
        }
        
        // Option + Space (keyCode 49)
        if flags.contains(.maskAlternate) && keyCode == 49 {
            Task { @MainActor in
                NotificationCenter.default.post(name: .toggleSidePanel, object: nil)
            }
            return nil // Consume event
        }
        
        // ESC key (keyCode 53)
        if keyCode == 53 {
            Task { @MainActor in
                NotificationCenter.default.post(name: .hideSearchBar, object: nil)
            }
        }
        
        return Unmanaged.passRetained(event)
    }
    
    func cleanup() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
    }
    
    deinit {
        cleanup()
    }
}
