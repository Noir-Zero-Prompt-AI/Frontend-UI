import Cocoa
import SwiftUI

@MainActor
class MenuBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?
    
    func setup() {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            // Use SF Symbol for menu bar icon
            let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .medium)
            let image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Grain AI")
            button.image = image?.withSymbolConfiguration(config)
            button.toolTip = "Grain AI Assistant"
        }
        
        // Create menu
        menu = NSMenu()
        
        // Add menu items
        let showIconItem = NSMenuItem(
            title: "Show Desktop Assistant",
            action: #selector(showDesktopAssistant),
            keyEquivalent: ""
        )
        showIconItem.target = self
        menu?.addItem(showIconItem)
        
        let showPanelItem = NSMenuItem(
            title: "Open Panel",
            action: #selector(showMainPanel),
            keyEquivalent: ""
        )
        showPanelItem.target = self
        menu?.addItem(showPanelItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let preferencesItem = NSMenuItem(
            title: "Preferences...",
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        preferencesItem.target = self
        menu?.addItem(preferencesItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(
            title: "Quit Grain",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu?.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func showDesktopAssistant() {
        NotificationCenter.default.post(name: .toggleSideIcon, object: nil)
    }
    
    @objc private func showMainPanel() {
        NotificationCenter.default.post(name: .toggleSidePanel, object: nil)
    }
    
    @objc private func openPreferences() {
        // TODO: Implement preferences window
        let alert = NSAlert()
        alert.messageText = "Preferences"
        alert.informativeText = "Preferences will be available in a future update."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
