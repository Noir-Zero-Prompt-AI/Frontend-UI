import SwiftUI

@Observable
@MainActor
class OnboardingViewModel {
    var currentScreen = 0
    var permissionsManager = PermissionsManager()
    
    var totalScreens: Int { 4 }
    
    var canProceed: Bool {
        if currentScreen == 2 { // Permissions screen
            return permissionsManager.hasScreenRecording && permissionsManager.hasAccessibility
        }
        return true
    }
    
    func next() {
        if currentScreen < totalScreens - 1 {
            withAnimation(AnimationCurves.standard) {
                currentScreen += 1
            }
        }
    }
    
    func previous() {
        if currentScreen > 0 {
            withAnimation(AnimationCurves.standard) {
                currentScreen -= 1
            }
        }
    }
    
    func skip() {
        withAnimation(AnimationCurves.standard) {
            currentScreen = totalScreens - 1
        }
    }
}
