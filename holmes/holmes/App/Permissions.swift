import Foundation
import AppKit
import AVFoundation
import CoreGraphics
import ScreenCaptureKit

struct PermissionManager {
    static func checkAccessibilityPermission() -> Bool {
        AXIsProcessTrusted()
    }
    
    static func requestAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options)
    }
    
    static func checkScreenRecordingPermission() -> Bool {
        var hasPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        
        SCShareableContent.getExcludingDesktopWindows(false, onScreenWindowsOnly: false) { content, error in
            hasPermission = (error == nil && content != nil)
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return hasPermission
    }
    
    static func openScreenRecordingSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func checkMicrophonePermission() -> Bool {
        AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    static func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    static var allRequiredPermissionsGranted: Bool {
        checkAccessibilityPermission() && checkScreenRecordingPermission()
    }
}
