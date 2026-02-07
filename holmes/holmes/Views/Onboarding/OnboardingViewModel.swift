import SwiftUI
import Combine
import AppKit
import ScreenCaptureKit

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case howItWorks = 1
    case permissions = 2
    case ready = 3
}

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var hasScreenRecordingPermission = false
    @Published var hasAccessibilityPermission = false
    @Published var hasAutomationPermission = false
    @Published var isCheckingPermissions = false
    
    var allPermissionsGranted: Bool {
        hasScreenRecordingPermission && hasAccessibilityPermission
    }
    
    var canProceedFromPermissions: Bool {
        allPermissionsGranted
    }
    
    func nextStep() {
        guard let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        withAnimation(NoirAnimations.smooth) {
            currentStep = nextIndex
        }
    }
    
    func previousStep() {
        guard let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        withAnimation(NoirAnimations.smooth) {
            currentStep = prevIndex
        }
    }
    
    func goToStep(_ step: OnboardingStep) {
        withAnimation(NoirAnimations.smooth) {
            currentStep = step
        }
    }
    
    func checkPermissions() {
        isCheckingPermissions = true
        
        hasAccessibilityPermission = AXIsProcessTrusted()
        hasScreenRecordingPermission = checkScreenRecordingPermission()
        hasAutomationPermission = true
        
        isCheckingPermissions = false
    }
    
    private func checkScreenRecordingPermission() -> Bool {
        var hasPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        
        SCShareableContent.getExcludingDesktopWindows(false, onScreenWindowsOnly: false) { content, error in
            hasPermission = (error == nil && content != nil)
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return hasPermission
    }
    
    func requestAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.checkPermissions()
        }
    }
    
    func openScreenRecordingSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") {
            NSWorkspace.shared.open(url)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.checkPermissions()
        }
    }
    
    func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.checkPermissions()
        }
    }
    
    func openAutomationSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
