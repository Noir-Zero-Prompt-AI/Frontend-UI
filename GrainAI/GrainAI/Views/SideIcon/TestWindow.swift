import Cocoa
import SwiftUI
import Lottie

// DESKTOP ASSISTANT - DRAGGABLE WITH LOTTIE ANIMATION
class TestWindow: NSWindow {
    private var initialLocation: NSPoint = .zero
    
    init() {
        // Create window at right-center position
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
        let x = screenFrame.maxX - 150
        let y = screenFrame.midY - 60
        
        super.init(
            contentRect: NSRect(x: x, y: y, width: 120, height: 120),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.title = "Grain Assistant"
        self.backgroundColor = .clear
        self.isOpaque = false
        self.level = .floating
        self.hasShadow = true
        self.ignoresMouseEvents = false
        self.isMovableByWindowBackground = true
        self.isMovable = true
        self.acceptsMouseMovedEvents = true
        
        // Create DRAGGABLE container view
        let containerView = DraggableView(frame: NSRect(x: 0, y: 0, width: 120, height: 120))
        containerView.onClicked = {
            NotificationCenter.default.post(name: .toggleSidePanel, object: nil)
            print("🔵 Panel toggle sent!")
        }
        
        // LOAD ANIMATED GIF WITH PROPER SETUP
        print("🎬 LOADING ANIMATED GIF")
        
        let gifPath = "/Users/rouler4wd/Downloads/noireye.gif"
        var gifWorked = false
        
        if let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
           let gifImage = NSImage(data: gifData) {
            print("✅ GIF loaded with \(gifImage.representations.count) representations")
            
            // Create image view for animated GIF
            let imageView = NSImageView(frame: NSRect(x: 10, y: 10, width: 100, height: 100))
            imageView.wantsLayer = true
            imageView.imageScaling = .scaleProportionallyUpOrDown
            imageView.animates = true
            imageView.image = gifImage
            
            // Force animation to start
            if let rep = gifImage.representations.first as? NSBitmapImageRep {
                print("✅ Image rep type: \(type(of: rep))")
            }
            
            containerView.wantsLayer = true
            containerView.addSubview(imageView)
            
            print("✅ GIF VIEW ADDED - should be animating!")
            gifWorked = true
        } else {
            print("❌ Failed to load GIF")
        }
        
        // If GIF failed, use fallback
        if !gifWorked {
            print("⚠️ Using fallback purple G")
            createFallbackIcon(in: containerView)
        }
        
        self.contentView = containerView
        print("🟢 Window setup complete")
    }
    
    private func createFallbackIcon(in container: NSView) {
        print("🟣 CREATING FALLBACK PURPLE 'G' ICON")
        
        // Purple circle background
        let circleView = NSView(frame: NSRect(x: 10, y: 10, width: 100, height: 100))
        circleView.wantsLayer = true
        circleView.layer?.cornerRadius = 50
        circleView.layer?.backgroundColor = NSColor.systemPurple.cgColor
        
        // Add "G" text in center
        let label = NSTextField(labelWithString: "G")
        label.frame = NSRect(x: 30, y: 30, width: 40, height: 40)
        label.font = NSFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.alignment = .center
        circleView.addSubview(label)
        
        // Add glow
        circleView.shadow = NSShadow()
        circleView.shadow?.shadowBlurRadius = 15
        circleView.shadow?.shadowOffset = NSSize(width: 0, height: 0)
        circleView.shadow?.shadowColor = NSColor.systemPurple.withAlphaComponent(0.6)
        
        container.addSubview(circleView)
        print("✅ FALLBACK PURPLE 'G' CREATED")
    }
    
    override func mouseEntered(with event: NSEvent) {
        // Scale up slightly on hover
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            self.animator().alphaValue = 1.0
            if let contentView = self.contentView {
                contentView.layer?.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
            }
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        // Scale back to normal
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            self.animator().alphaValue = 0.9
            if let contentView = self.contentView {
                contentView.layer?.transform = CATransform3DIdentity
            }
        }
    }
}
