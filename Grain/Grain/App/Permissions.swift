import Foundation
import AppKit
import ApplicationServices

@Observable
@MainActor
class PermissionsManager {
    var hasScreenRecording = false
    var hasAccessibility = false
    var hasAutomation = false
    
    func checkAllPermissions() {
        checkScreenRecording()
        checkAccessibility()
    }
    
    func checkScreenRecording() {
        // Check if we can capture screen content
        // For now, we'll use a simple check
        hasScreenRecording = CGPreflightScreenCaptureAccess()
    }
    
    func checkAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        hasAccessibility = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
    func requestScreenRecording() {
        CGRequestScreenCaptureAccess()
    }
    
    func requestAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
    func openSystemPreferences(for permission: PermissionType) {
        switch permission {
        case .screenRecording:
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
                NSWorkspace.shared.open(url)
            }
        case .accessibility:
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        case .automation:
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

enum PermissionType {
    case screenRecording
    case accessibility
    case automation
}
