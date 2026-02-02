import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var searchBarWindow: NSWindow?
    var sideIconWindow: NSWindow?
    var mainPanelWindow: NSWindow?
    var hotkeyManager: HotkeyManager?
    var permissionsManager = PermissionsManager()
    var menuBarController: MenuBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // USE REGULAR APP - LET'S SEE A WINDOW FIRST
        NSApp.setActivationPolicy(.regular)
        
        print("🔴🔴🔴 CREATING SIMPLE TEST WINDOW 🔴🔴🔴")
        
        // Create simple test window
        let testWindow = TestWindow()
        sideIconWindow = testWindow
        
        print("🔴 Showing test window...")
        testWindow.makeKeyAndOrderFront(nil)
        
        print("🔴 Activating app...")
        NSApp.activate(ignoringOtherApps: true)
        
        print("🔴 Window shown! Check your screen for RED WINDOW")
        print("🔴 Window isVisible: \(testWindow.isVisible)")
        print("🔴 Window frame: \(testWindow.frame)")
        print("🔴 All windows count: \(NSApp.windows.count)")
        
        // Setup menu bar icon
        menuBarController = MenuBarController()
        menuBarController?.setup()
        
        // Setup global hotkeys
        hotkeyManager = HotkeyManager()
        hotkeyManager?.setup()
        
        // Setup notification observers
        setupNotificationObservers()
        
        // Check permissions
        permissionsManager.checkAllPermissions()
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
            rootView: OnboardingFlow(onComplete: {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                window.close()
                self.showSideIcon()
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
        
        // NEW: Option+Space toggles side ICON
        NotificationCenter.default.addObserver(
            forName: .toggleSideIcon,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.toggleSideIcon()
            }
        }
        
        // NEW: Clicking icon toggles PANEL
        NotificationCenter.default.addObserver(
            forName: .toggleSidePanel,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.toggleMainPanel()
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
    
    // FORCE SHOW ICON - NO TOGGLE, JUST SHOW IT
    func showSideIconNow() {
        print("🔴 showSideIconNow() - CREATING AND SHOWING WINDOW")
        
        let window = SideIconWindow()
        let hostingView = NSHostingView(rootView: SideIconView())
        hostingView.frame = NSRect(x: 0, y: 0, width: 120, height: 120)
        window.contentView = hostingView
        sideIconWindow = window
        
        print("🔴 Window created at: \(window.frame)")
        
        // CRITICAL: Show window with multiple methods
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        window.orderFront(nil)
        
        // Make window visible
        window.setIsVisible(true)
        
        print("🔴 Window isVisible: \(window.isVisible)")
        print("🔴 Window level: \(window.level.rawValue)")
        print("🔴 Window alpha: \(window.alphaValue)")
        print("🔴 Screen main: \(NSScreen.main?.frame ?? .zero)")
    }
    
    // NEW: Toggle desktop icon visibility (Option+Space)
    func toggleSideIcon() {
        print("🟢 toggleSideIcon() called")
        
        if sideIconWindow == nil {
            showSideIconNow()
            return
        }
        
        if sideIconWindow?.isVisible == true {
            print("🟢 Hiding side icon")
            sideIconWindow?.orderOut(nil)
        } else {
            print("🟢 Showing side icon")
            sideIconWindow?.makeKeyAndOrderFront(nil)
            sideIconWindow?.orderFrontRegardless()
        }
    }
    
    // NEW: Toggle main panel (click icon)
    func toggleMainPanel() {
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
    static let toggleSideIcon = Notification.Name("toggleSideIcon")      // NEW: Show/hide desktop icon
    static let toggleSidePanel = Notification.Name("toggleSidePanel")    // NEW: Show/hide main panel
    static let hideSearchBar = Notification.Name("hideSearchBar")
}
