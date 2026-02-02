import SwiftUI

struct OnboardingFlow: View {
    @State private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background with film grain
            backgroundView
            
            // Screen content
            TabView(selection: $viewModel.currentScreen) {
                WelcomeScreen(viewModel: viewModel)
                    .tag(0)
                
                HowItWorksScreen(viewModel: viewModel)
                    .tag(1)
                
                PermissionsScreen(viewModel: viewModel)
                    .tag(2)
                
                ReadyScreen(viewModel: viewModel, onComplete: onComplete)
                    .tag(3)
            }
            .tabViewStyle(.automatic)
        }
        .frame(width: 600, height: 700)
    }
    
    private var backgroundView: some View {
        ZStack {
            // Noir gradient background
            LinearGradient(
                colors: [
                    NoirColors.charcoalGray,
                    NoirColors.shadowBlack
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Film grain overlay
            FilmGrainOverlay(opacity: 0.12)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingFlow(onComplete: {
        print("Onboarding complete")
    })
}
