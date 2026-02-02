import Cocoa

// Custom view that handles dragging
class DraggableView: NSView {
    var onClicked: (() -> Void)?
    private var mouseDownLocation: NSPoint?
    
    override func mouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        print("🔵 DraggableView mouseDown")
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let window = self.window,
              let mouseDown = mouseDownLocation else { return }
        
        let currentLocation = event.locationInWindow
        let newOrigin = NSPoint(
            x: window.frame.origin.x + (currentLocation.x - mouseDown.x),
            y: window.frame.origin.y + (currentLocation.y - mouseDown.y)
        )
        
        window.setFrameOrigin(newOrigin)
        print("🔵 DRAGGING to: \(newOrigin)")
    }
    
    override func mouseUp(with event: NSEvent) {
        // If mouse didn't move much, it's a click
        if let mouseDown = mouseDownLocation {
            let currentLocation = event.locationInWindow
            let distance = hypot(currentLocation.x - mouseDown.x, currentLocation.y - mouseDown.y)
            
            if distance < 5 {
                print("🔵 CLICK detected!")
                onClicked?()
            }
        }
        
        mouseDownLocation = nil
    }
}
