import Cocoa
import SwiftUI

class SideIconWindow: NSWindow {
    private let iconSize: CGFloat = 80
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 80, height: 80),
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
            .fullScreenAuxiliary  // Overlay on fullscreen apps
        ]
        
        self.isMovableByWindowBackground = true
        self.hasShadow = false
        
        // Load saved position or use default
        if let savedPosition = loadSavedPosition() {
            self.setFrameOrigin(savedPosition)
        } else {
            positionAtCenterRight()
        }
        
        // Save position when moved
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            self?.savePosition()
        }
    }
    
    func positionAtCenterRight() {
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let x = screenFrame.maxX - 100
            let y = screenFrame.minY + (screenFrame.height - iconSize) / 2
            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
    
    private func savePosition() {
        let position = self.frame.origin
        UserDefaults.standard.set(position.x, forKey: "sideIconX")
        UserDefaults.standard.set(position.y, forKey: "sideIconY")
    }
    
    private func loadSavedPosition() -> NSPoint? {
        let x = UserDefaults.standard.double(forKey: "sideIconX")
        let y = UserDefaults.standard.double(forKey: "sideIconY")
        
        if x != 0 || y != 0 {
            return NSPoint(x: x, y: y)
        }
        return nil
    }
    
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}
