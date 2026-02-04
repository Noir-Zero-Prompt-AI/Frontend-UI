import SwiftUI
import AppKit

class SearchBarWindowController: NSObject {
    static let shared = SearchBarWindowController()
    
    private var window: NSWindow?
    private var isVisible = false
    
    override private init() {
        super.init()
    }
    
    func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }
    
    func show() {
        guard !isVisible else { return }
        
        if window == nil {
            createWindow()
        }
        
        guard let window = window, let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowWidth: CGFloat = 700
        let windowHeight: CGFloat = 200
        let topOffset: CGFloat = 120
        
        let x = screenFrame.origin.x + (screenFrame.width - windowWidth) / 2
        let y = screenFrame.origin.y + screenFrame.height - windowHeight - topOffset
        
        window.setFrame(NSRect(x: x, y: y, width: windowWidth, height: windowHeight), display: true)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        isVisible = true
    }
    
    func hide() {
        window?.orderOut(nil)
        isVisible = false
    }
    
    private func createWindow() {
        let window = SearchBarPanel(
            contentRect: NSRect(x: 0, y: 0, width: 700, height: 200),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isMovableByWindowBackground = false
        window.hasShadow = false
        
        let hostingView = NSHostingView(rootView: SearchBarHostView(onDismiss: { [weak self] in
            self?.hide()
        }))
        hostingView.frame = window.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        
        self.window = window
    }
}

class SearchBarPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    override func resignKey() {
        super.resignKey()
        SearchBarWindowController.shared.hide()
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            SearchBarWindowController.shared.hide()
            return
        }
        super.keyDown(with: event)
    }
}

struct SearchBarHostView: View {
    let onDismiss: () -> Void
    @State private var isVisible = true
    
    var body: some View {
        ZStack {
            Color.clear
            
            SearchBarView(isVisible: $isVisible)
                .onChange(of: isVisible) { oldValue, newValue in
                    if !newValue {
                        onDismiss()
                    }
                }
        }
    }
}
