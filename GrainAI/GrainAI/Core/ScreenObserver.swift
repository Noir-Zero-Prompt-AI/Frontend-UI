import Foundation

// Stub for future screen observation functionality
@Observable
@MainActor
class ScreenObserver {
    var isObserving = false
    var lastActivity: Date?
    
    func startObserving() {
        isObserving = true
        lastActivity = Date()
    }
    
    func stopObserving() {
        isObserving = false
    }
    
    func captureContext() -> String {
        // Placeholder for screen capture and OCR
        return "Working on macOS project"
    }
}
