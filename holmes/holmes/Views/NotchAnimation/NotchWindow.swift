import SwiftUI
import AppKit

class NotchWindowController: NSObject, ObservableObject {
    static let shared = NotchWindowController()
    
    private var window: NSWindow?
    @Published var viewModel = NotchViewModel()
    @Published var isVisible: Bool = false
    
    override private init() {
        super.init()
    }
    
    var hasNotch: Bool {
        NotchDetector.hasNotch
    }
    
    func show() {
        guard hasNotch, !isVisible else { return }
        
        if window == nil {
            createWindow()
        }
        
        positionWindow()
        window?.orderFront(nil)
        isVisible = true
        viewModel.startIdleAnimation()
    }
    
    func hide() {
        viewModel.stopIdleAnimation()
        window?.orderOut(nil)
        isVisible = false
    }
    
    private func createWindow() {
        let window = NotchPanel(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 100),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.ignoresMouseEvents = false
        window.hasShadow = false
        
        let hostingView = NSHostingView(rootView: NotchHostView(controller: self))
        hostingView.frame = window.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        
        self.window = window
    }
    
    private func positionWindow() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        let notchFrame = NotchDetector.notchFrame
        let windowWidth: CGFloat = 320
        
        let x = screen.frame.midX - windowWidth / 2
        let y = notchFrame.origin.y - 10
        
        window.setFrame(NSRect(x: x, y: y, width: windowWidth, height: 100), display: true)
    }
    
    func updateForState() {
        guard let window = window else { return }
        
        switch viewModel.state {
        case .idle:
            window.setContentSize(NSSize(width: 320, height: 50))
        case .active:
            window.setContentSize(NSSize(width: 320, height: 80))
        case .expanded:
            window.setContentSize(NSSize(width: 320, height: 140))
        }
        
        positionWindow()
    }
}

class NotchPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

struct NotchHostView: View {
    @ObservedObject var controller: NotchWindowController
    
    var body: some View {
        VStack {
            Spacer()
            
            NotchView(viewModel: controller.viewModel) {
                MainPanelWindowController.shared.toggle()
            }
        }
        .onChange(of: controller.viewModel.state) { _, _ in
            controller.updateForState()
        }
    }
}
