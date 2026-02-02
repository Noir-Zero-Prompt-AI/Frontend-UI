import SwiftUI

@main
struct GrainApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Make app run as menu bar agent (no dock icon)
        NSApp.setActivationPolicy(.accessory)
    }
    
    var body: some Scene {
        // Empty window group - app runs in background
        Settings {
            EmptyView()
        }
    }
}
