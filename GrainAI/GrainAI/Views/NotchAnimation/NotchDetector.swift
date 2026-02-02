import AppKit

struct NotchDetector {
    /// Checks if the current Mac has a notch
    static func hasNotch() -> Bool {
        guard let screen = NSScreen.main else { return false }
        
        // Check for safe area insets (notch has top inset > 0)
        if #available(macOS 12.0, *) {
            return screen.safeAreaInsets.top > 0
        }
        
        return false
    }
    
    /// Returns the notch area frame if available
    static func notchFrame() -> NSRect? {
        guard let screen = NSScreen.main, hasNotch() else { return nil }
        
        let screenFrame = screen.frame
        let safeArea = screen.safeAreaInsets
        
        // Approximate notch dimensions
        let notchWidth: CGFloat = 200
        let notchHeight = safeArea.top
        let notchX = (screenFrame.width - notchWidth) / 2
        let notchY = screenFrame.maxY - notchHeight
        
        return NSRect(x: notchX, y: notchY, width: notchWidth, height: notchHeight)
    }
}
