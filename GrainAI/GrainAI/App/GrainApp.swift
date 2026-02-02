import SwiftUI

@main
struct GrainApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Empty window group - app runs in background
        Settings {
            EmptyView()
        }
    }
}
