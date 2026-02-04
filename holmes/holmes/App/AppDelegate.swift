import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var onboardingWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupApp()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        LocalHotkeyManager.shared.stop()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            MainPanelWindowController.shared.show()
        }
        return true
    }
    
    private func setupApp() {
        MenuBarManager.shared.setup()
        
        setupHotkeys()
        
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
            startMainApp()
        } else {
            showOnboarding()
        }
    }
    
    private func setupHotkeys() {
        LocalHotkeyManager.shared.onControlSpace = {
            SearchBarWindowController.shared.toggle()
        }
        
        LocalHotkeyManager.shared.onOptionSpace = {
            if !SideIconWindowController.shared.isVisible {
                SideIconWindowController.shared.show()
            }
            MainPanelWindowController.shared.toggle()
        }
        
        LocalHotkeyManager.shared.onCommandBackslash = {
            SideIconWindowController.shared.toggle()
        }
        
        LocalHotkeyManager.shared.start()
    }
    
    private func showOnboarding() {
        let onboardingView = OnboardingFlow {
            DispatchQueue.main.async { [weak self] in
                self?.onboardingWindow?.close()
                self?.onboardingWindow = nil
                self?.startMainApp()
            }
        }
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.center()
        window.contentView = NSHostingView(rootView: onboardingView)
        window.makeKeyAndOrderFront(nil)
        
        self.onboardingWindow = window
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func startMainApp() {
        SideIconWindowController.shared.show()
        
        if NotchDetector.hasNotch {
            NotchWindowController.shared.show()
        }
    }
}
