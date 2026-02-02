import SwiftUI

struct WelcomeScreen: View {
    let viewModel: OnboardingViewModel
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Large icon
            Image(systemName: "person.fill.viewfinder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundStyle(NoirColors.paperWhite)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.8)
                .animation(AnimationCurves.spring.delay(0.1), value: isVisible)
            
            VStack(spacing: 12) {
                // App name
                Text("Grain")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(NoirColors.paperWhite)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(AnimationCurves.spring.delay(0.2), value: isVisible)
                
                // Tagline
                Text("Zero Prompt AI for macOS")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(NoirColors.fogGray)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(AnimationCurves.spring.delay(0.3), value: isVisible)
            }
            
            // Value proposition
            Text("I learn from your actions and help\nbefore you even ask.")
                .font(.system(size: 16))
                .foregroundStyle(NoirColors.paperWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 8)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(AnimationCurves.spring.delay(0.4), value: isVisible)
            
            Spacer()
            
            // CTA
            NoirButton(title: "Get Started", action: {
                viewModel.next()
            }, style: .primary)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(AnimationCurves.spring.delay(0.5), value: isVisible)
            
            Button("Skip to permissions") {
                viewModel.skip()
            }
            .font(.system(size: 13))
            .foregroundStyle(NoirColors.fogGray)
            .buttonStyle(.plain)
            .opacity(isVisible ? 1 : 0)
            .animation(AnimationCurves.spring.delay(0.6), value: isVisible)
        }
        .padding(60)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    WelcomeScreen(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 700)
        .background(NoirColors.charcoalGray)
}
