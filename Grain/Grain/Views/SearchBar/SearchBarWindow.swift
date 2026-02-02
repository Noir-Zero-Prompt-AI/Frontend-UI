import Cocoa
import SwiftUI

class SearchBarWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 150),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Set window level above fullscreen windows
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.screenSaverWindow)) + 1)
        self.isOpaque = false
        self.backgroundColor = .clear
        
        // Allow window to appear in all spaces and over fullscreen apps
        self.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .fullScreenAuxiliary  // This allows overlay on fullscreen apps
        ]
        
        self.hasShadow = true
        self.ignoresMouseEvents = false
        
        // Position at top-center of screen
        positionAtTopCenter()
        
        // Setup to dismiss on focus loss
        setupFocusObserver()
    }
    
    func positionAtTopCenter() {
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = (screenFrame.width - 800) / 2 + screenFrame.minX
            let y = screenFrame.maxY - 250  // 100-150px from top
            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
    
    private func setupFocusObserver() {
        NotificationCenter.default.addObserver(
            forName: NSWindow.didResignKeyNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            // Dismiss when focus is lost
            self?.orderOut(nil)
        }
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
}
