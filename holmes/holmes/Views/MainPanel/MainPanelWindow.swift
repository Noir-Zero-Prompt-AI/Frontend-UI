import SwiftUI
import AppKit

class MainPanelWindowController: NSObject, ObservableObject {
    static let shared = MainPanelWindowController()
    
    private var window: NSWindow?
    @Published var isVisible: Bool = false
    
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
        
        positionWindow()
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        isVisible = true
    }
    
    func hide() {
        window?.orderOut(nil)
        isVisible = false
    }
    
    private func createWindow() {
        let window = MainPanelPanel(
            contentRect: NSRect(x: 0, y: 0, width: 380, height: 520),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isMovableByWindowBackground = true
        window.hasShadow = false
        
        let hostingView = NSHostingView(rootView: MainPanelHostView(controller: self))
        hostingView.frame = window.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        
        self.window = window
    }
    
    private func positionWindow() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowFrame = window.frame
        
        let sideIconController = SideIconWindowController.shared
        if sideIconController.isVisible, let sideIconWindow = NSApp.windows.first(where: { $0 is SideIconPanel }) {
            let sideIconFrame = sideIconWindow.frame
            let x = sideIconFrame.origin.x - windowFrame.width - 20
            let y = sideIconFrame.midY - windowFrame.height / 2
            window.setFrameOrigin(NSPoint(x: max(screenFrame.origin.x, x), y: y))
        } else {
            let x = screenFrame.maxX - windowFrame.width - 80
            let y = screenFrame.midY - windowFrame.height / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}

class MainPanelPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    
    override func resignKey() {
        super.resignKey()
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            MainPanelWindowController.shared.hide()
            return
        }
        super.keyDown(with: event)
    }
}

struct MainPanelHostView: View {
    @ObservedObject var controller: MainPanelWindowController
    
    var body: some View {
        ZStack {
            Color.clear
            
            MainPanelView(isVisible: $controller.isVisible)
                .onChange(of: controller.isVisible) { oldValue, newValue in
                    if !newValue {
                        controller.hide()
                    }
                }
        }
    }
}
