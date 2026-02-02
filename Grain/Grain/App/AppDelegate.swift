import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var searchBarWindow: NSWindow?
    var sideIconWindow: NSWindow?
    var mainPanelWindow: NSWindow?
    var hotkeyManager: HotkeyManager?
    var permissionsManager = PermissionsManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Setup global hotkeys
        hotkeyManager = HotkeyManager()
        hotkeyManager?.setup()
        
        // Setup notification observers
        setupNotificationObservers()
        
        // Check permissions
        permissionsManager.checkAllPermissions()
        
        // Check if onboarding is complete
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            showOnboarding()
        } else {
            // Show side icon immediately
            showSideIcon()
        }
    }
    
    func showOnboarding() {
        // Create onboarding window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Welcome to Grain"
        window.center()
        window.contentView = NSHostingView(
            rootView: OnboardingFlow(onComplete: { [weak self] in
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                window.close()
                self?.showSideIcon()
            })
        )
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: .openSearchBar,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.showSearchBar()
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .toggleSidePanel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.toggleSidePanel()
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: .hideSearchBar,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.hideSearchBar()
            }
        }
    }
    
    func showSearchBar() {
        if searchBarWindow == nil {
            let window = SearchBarWindow()
            window.contentView = NSHostingView(rootView: SearchBarView())
            searchBarWindow = window
        }
        
        searchBarWindow?.makeKeyAndOrderFront(nil)
        searchBarWindow?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hideSearchBar() {
        searchBarWindow?.orderOut(nil)
    }
    
    func showSideIcon() {
        if sideIconWindow == nil {
            let window = SideIconWindow()
            window.contentView = NSHostingView(rootView: SideIconView())
            sideIconWindow = window
        }
        
        sideIconWindow?.makeKeyAndOrderFront(nil)
    }
    
    func toggleSidePanel() {
        if mainPanelWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window.level = .floating
            window.isOpaque = false
            window.backgroundColor = .clear
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            
            // Position near cursor or side icon
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let x = screenFrame.maxX - 420
                let y = (screenFrame.height - 600) / 2
                window.setFrameOrigin(NSPoint(x: x, y: y))
            }
            
            window.contentView = NSHostingView(rootView: MainPanelView())
            mainPanelWindow = window
        }
        
        if mainPanelWindow?.isVisible == true {
            mainPanelWindow?.orderOut(nil)
        } else {
            mainPanelWindow?.makeKeyAndOrderFront(nil)
            mainPanelWindow?.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}

// Notification names
extension Notification.Name {
    static let openSearchBar = Notification.Name("openSearchBar")
    static let toggleSidePanel = Notification.Name("toggleSidePanel")
    static let hideSearchBar = Notification.Name("hideSearchBar")
}
