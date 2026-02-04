import AppKit
import SwiftUI

class MenuBarManager: NSObject {
    static let shared = MenuBarManager()
    
    private var statusItem: NSStatusItem?
    private var menu: NSMenu?
    
    var isPaused: Bool = false {
        didSet {
            updateMenuItemTitles()
        }
    }
    
    override private init() {
        super.init()
    }
    
    func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "magnifyingglass", accessibilityDescription: "Holmes")
            button.image?.isTemplate = true
        }
        
        setupMenu()
    }
    
    private func setupMenu() {
        menu = NSMenu()
        
        let statusItem = NSMenuItem(title: "Holmes is running", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu?.addItem(statusItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let searchItem = NSMenuItem(title: "Open Search", action: #selector(openSearch), keyEquivalent: " ")
        searchItem.keyEquivalentModifierMask = .control
        searchItem.target = self
        menu?.addItem(searchItem)
        
        let panelItem = NSMenuItem(title: "Open Assistant", action: #selector(openPanel), keyEquivalent: " ")
        panelItem.keyEquivalentModifierMask = .option
        panelItem.target = self
        menu?.addItem(panelItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let pauseItem = NSMenuItem(title: "Pause Holmes", action: #selector(togglePause), keyEquivalent: "p")
        pauseItem.keyEquivalentModifierMask = .command
        pauseItem.target = self
        menu?.addItem(pauseItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu?.addItem(settingsItem)
        
        let aboutItem = NSMenuItem(title: "About Holmes", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu?.addItem(aboutItem)
        
        menu?.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit Holmes", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu?.addItem(quitItem)
        
        self.statusItem?.menu = menu
    }
    
    private func updateMenuItemTitles() {
        if let pauseItem = menu?.item(withTitle: isPaused ? "Resume Holmes" : "Pause Holmes") {
            pauseItem.title = isPaused ? "Resume Holmes" : "Pause Holmes"
        }
        
        if let statusItem = menu?.items.first {
            statusItem.title = isPaused ? "Holmes is paused" : "Holmes is running"
        }
        
        if let button = statusItem?.button {
            button.image = NSImage(
                systemSymbolName: isPaused ? "pause.circle" : "magnifyingglass",
                accessibilityDescription: "Holmes"
            )
            button.image?.isTemplate = true
        }
    }
    
    @objc private func openSearch() {
        SearchBarWindowController.shared.show()
    }
    
    @objc private func openPanel() {
        SideIconWindowController.shared.show()
        MainPanelWindowController.shared.show()
    }
    
    @objc private func togglePause() {
        isPaused.toggle()
        
        if isPaused {
            SideIconWindowController.shared.iconState = .dormant
        }
    }
    
    @objc private func openSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
    
    @objc private func showAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
