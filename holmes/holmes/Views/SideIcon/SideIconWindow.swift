import SwiftUI
import AppKit

class SideIconWindowController: NSObject, ObservableObject {
    static let shared = SideIconWindowController()
    
    private var window: NSWindow?
    @Published var iconState: IconState = .dormant
    @Published var isExpanded: Bool = false
    @Published var isVisible: Bool = false
    
    private var currentPosition: NSPoint?
    private let iconSize: CGFloat = 60
    
    private let positionKey = "SideIconPosition"
    
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
    
    private func createWindow() {
        let window = SideIconPanel(
            contentRect: NSRect(x: 0, y: 0, width: iconSize, height: iconSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovableByWindowBackground = true
        window.hasShadow = false
        
        let hostingView = NSHostingView(rootView: SideIconHostView(controller: self))
        hostingView.frame = window.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        
        window.contentView = hostingView
        window.delegate = self
        
        self.window = window
    }
    
    private func positionWindow() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        let position: NSPoint
        if let saved = currentPosition {
            position = saved
        } else {
            let screenFrame = screen.visibleFrame
            position = NSPoint(
                x: screenFrame.maxX - iconSize - 20,
                y: screenFrame.midY - iconSize / 2
            )
        }
        
        window.setFrameOrigin(position)
    }
    
    private func loadSavedPosition() {
        if let data = UserDefaults.standard.data(forKey: positionKey),
           let point = try? JSONDecoder().decode(CodablePoint.self, from: data) {
            currentPosition = NSPoint(x: point.x, y: point.y)
        }
    }
    
    func savePosition() {
        guard let window = window else { return }
        let origin = window.frame.origin
        currentPosition = origin
        
        let point = CodablePoint(x: origin.x, y: origin.y)
        if let data = try? JSONEncoder().encode(point) {
            UserDefaults.standard.set(data, forKey: positionKey)
        }
    }
}

extension SideIconWindowController: NSWindowDelegate {
    func windowDidMove(_ notification: Notification) {
        savePosition()
    }
}

struct CodablePoint: Codable {
    let x: CGFloat
    let y: CGFloat
}

class SideIconPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

struct SideIconHostView: View {
    @ObservedObject var controller: SideIconWindowController
    
    var body: some View {
        SideIconView(
            state: $controller.iconState,
            isExpanded: $controller.isExpanded
        ) {
            MainPanelWindowController.shared.toggle()
        }
    }
}
