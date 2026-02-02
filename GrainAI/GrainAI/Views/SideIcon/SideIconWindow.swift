import Cocoa
import SwiftUI

class SideIconWindow: NSWindow {
    private let iconSize: CGFloat = 80
    
    init() {
        // Start with a position on screen
        let startRect = NSRect(x: 100, y: 100, width: 120, height: 120)
        
        super.init(
            contentRect: startRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        print("🔴 SideIconWindow init - creating window")
        
        // CRITICAL: Set window level VERY HIGH
        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        
        // Allow window to appear in all spaces and over fullscreen apps
        self.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .fullScreenAuxiliary
        ]
        
        self.isMovableByWindowBackground = true
        self.hasShadow = true
        self.ignoresMouseEvents = false
        
        // Position it
        if let savedPosition = loadSavedPosition() {
            print("🔴 Using saved position: \(savedPosition)")
            self.setFrameOrigin(savedPosition)
        } else {
            print("🔴 Using default position")
            positionAtCenterRight()
        }
        
        print("🔴 Final window frame: \(self.frame)")
        
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
