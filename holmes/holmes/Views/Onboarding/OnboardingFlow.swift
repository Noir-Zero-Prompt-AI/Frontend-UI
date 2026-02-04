import SwiftUI

struct OnboardingFlow: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            NoirColors.charcoalGray
                .ignoresSafeArea()
            
            GrainOverlay(opacity: 0.05)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    if viewModel.currentStep != .welcome {
                        StepIndicator(
                            currentStep: viewModel.currentStep.rawValue,
                            totalSteps: OnboardingStep.allCases.count
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal, 40)
                
                Group {
                    switch viewModel.currentStep {
                    case .welcome:
                        WelcomeScreen(viewModel: viewModel)
                    case .howItWorks:
                        HowItWorksScreen(viewModel: viewModel)
                    case .permissions:
                        PermissionsScreen(viewModel: viewModel)
                    case .ready:
                        ReadyScreen(viewModel: viewModel, onComplete: onComplete)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .frame(minWidth: 600, minHeight: 700)
    }
}

struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? NoirColors.paperWhite : NoirColors.smokeGray)
                    .frame(width: index == currentStep ? 24 : 8, height: 8)
                    .animation(NoirAnimations.smooth, value: currentStep)
            }
        }
    }
}

#Preview {
    OnboardingFlow {}
}
