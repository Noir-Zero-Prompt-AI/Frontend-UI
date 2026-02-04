import AppKit

struct NotchDetector {
    static var hasNotch: Bool {
        guard let screen = NSScreen.main else { return false }
        
        if #available(macOS 12.0, *) {
            return screen.safeAreaInsets.top > 0
        }
        
        return false
    }
    
    static var notchWidth: CGFloat {
        guard hasNotch else { return 0 }
        return 180
    }
    
    static var notchHeight: CGFloat {
        guard hasNotch else { return 0 }
        
        if let screen = NSScreen.main {
            if #available(macOS 12.0, *) {
                return screen.safeAreaInsets.top
            }
        }
        
        return 32
    }
    
    static var notchFrame: NSRect {
        guard hasNotch, let screen = NSScreen.main else {
            return .zero
        }
        
        let screenFrame = screen.frame
        let notchX = screenFrame.midX - notchWidth / 2
        let notchY = screenFrame.maxY - notchHeight
        
        return NSRect(
            x: notchX,
            y: notchY,
            width: notchWidth,
            height: notchHeight
        )
    }
}
