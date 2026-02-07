import SwiftUI
import AppKit

class SideIconWindowController: NSObject, ObservableObject {
    static let shared = SideIconWindowController()
    
    private var window: NSWindow?
    @Published var iconState: IconState = .dormant
    @Published var isExpanded: Bool = false
    @Published var isVisible: Bool = false
    @Published var isBlinking: Bool = false
    
    private var currentYPosition: CGFloat?
    private let characterWidth: CGFloat = 120
    private let characterHeight: CGFloat = 120
    private let peekAmount: CGFloat = 60
    
    private let positionKey = "SideCharacterYPosition"
    
    override private init() {
        super.init()
        loadSavedPosition()
    }
    
    func show() {
        guard !isVisible else { return }
        
        if window == nil {
            createWindow()
        }
        
        positionWindow()
        window?.orderFront(nil)
        isVisible = true
    }
    
    func hide() {
        window?.orderOut(nil)
        isVisible = false
    }
    
    func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }
    
    func setExpanded(_ expanded: Bool) {
        isExpanded = expanded
        repositionForExpandState()
    }
    
    private func repositionForExpandState() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let visibleWidth = isExpanded ? characterWidth : peekAmount
        let newX = screenFrame.maxX - visibleWidth
        
        var frame = window.frame
        frame.origin.x = newX
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(frame, display: true)
        }
    }
    
    private func createWindow() {
        let window = SideIconPanel(
            contentRect: NSRect(x: 0, y: 0, width: characterWidth, height: characterHeight),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovableByWindowBackground = false
        window.hasShadow = false
        
        let hostingView = NSHostingView(rootView: SideCharacterHostView(controller: self))
        hostingView.frame = window.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        window.delegate = self
        
        self.window = window
        
        setupDragGesture()
    }
    
    private func setupDragGesture() {
        var isDragging = false
        var dragStartY: CGFloat = 0
        var windowStartY: CGFloat = 0
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
            guard let self = self, let window = self.window else { return event }
            
            let locationInWindow = event.locationInWindow
            let locationOnScreen = window.convertPoint(toScreen: locationInWindow)
            
            if window.frame.contains(locationOnScreen) {
                isDragging = true
                dragStartY = locationOnScreen.y
                windowStartY = window.frame.origin.y
            }
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged) { [weak self] event in
            guard let self = self, isDragging, let window = self.window, let screen = NSScreen.main else { return event }
            
            let currentY = NSEvent.mouseLocation.y
            let deltaY = currentY - dragStartY
            var newY = windowStartY + deltaY
            
            let screenFrame = screen.visibleFrame
            newY = max(screenFrame.minY, min(newY, screenFrame.maxY - self.characterHeight))
            
            var frame = window.frame
            frame.origin.y = newY
            window.setFrame(frame, display: true)
            
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp) { [weak self] event in
            if isDragging {
                isDragging = false
                self?.savePosition()
            }
            return event
        }
    }
    
    private func positionWindow() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        
        let yPosition: CGFloat
        if let saved = currentYPosition {
            yPosition = saved
        } else {
            yPosition = screenFrame.midY - characterHeight / 2
        }
        
        let xPosition = screenFrame.maxX - peekAmount
        
        window.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
    }
    
    private func loadSavedPosition() {
        currentYPosition = UserDefaults.standard.object(forKey: positionKey) as? CGFloat
    }
    
    func savePosition() {
        guard let window = window else { return }
        currentYPosition = window.frame.origin.y
        UserDefaults.standard.set(currentYPosition, forKey: positionKey)
    }
}

extension SideIconWindowController: NSWindowDelegate {
    func windowDidMove(_ notification: Notification) {
        savePosition()
    }
}

class SideIconPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

struct SideCharacterHostView: View {
    @ObservedObject var controller: SideIconWindowController
    
    var body: some View {
        SideCharacterView(
            isExpanded: $controller.isExpanded,
            isBlinking: $controller.isBlinking
        ) {
            controller.setExpanded(controller.isExpanded)
            if controller.isExpanded {
                MainPanelWindowController.shared.show()
            }
        }
    }
}
