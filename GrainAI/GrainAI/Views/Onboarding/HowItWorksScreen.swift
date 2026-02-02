import SwiftUI

struct HowItWorksScreen: View {
    let viewModel: OnboardingViewModel
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            // Header
            Text("How Grain Works")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(NoirColors.paperWhite)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : -20)
                .animation(AnimationCurves.spring.delay(0.1), value: isVisible)
            
            // Three panels
            HStack(spacing: 30) {
                featurePanel(
                    icon: "command",
                    title: "Search",
                    subtitle: "Control+Space",
                    description: "Quick commands and natural language queries",
                    delay: 0.2
                )
                
                featurePanel(
                    icon: "sidebar.right",
                    title: "Assistant",
                    subtitle: "Option+Space",
                    description: "Full panel with context and suggestions",
                    delay: 0.3
                )
                
                featurePanel(
                    icon: "bolt.fill",
                    title: "Automatic",
                    subtitle: "Zero Prompt",
                    description: "I learn patterns and work autonomously",
                    delay: 0.4
                )
            }
            .opacity(isVisible ? 1 : 0)
            
            Spacer()
            
            // Navigation
            HStack(spacing: 16) {
                NoirButton(title: "Back", action: {
                    viewModel.previous()
                }, style: .ghost)
                
                NoirButton(title: "Continue", action: {
                    viewModel.next()
                }, style: .primary)
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(AnimationCurves.spring.delay(0.5), value: isVisible)
        }
        .padding(60)
        .onAppear {
            isVisible = true
        }
    }
    
    private func featurePanel(icon: String, title: String, subtitle: String, description: String, delay: Double) -> some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(NoirColors.paperWhite)
                .frame(width: 80, height: 80)
                .background(NoirColors.smokeGray.opacity(0.3))
                .clipShape(Circle())
            
            // Title
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(NoirColors.paperWhite)
            
            // Subtitle (keyboard shortcut)
            Text(subtitle)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(NoirColors.fogGray)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(NoirColors.smokeGray.opacity(0.5))
                .clipShape(.rect(cornerRadius: 6))
            
            // Description
            Text(description)
                .font(.system(size: 13))
                .foregroundStyle(NoirColors.paperWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .frame(height: 60)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white.opacity(0.03))
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isVisible ? 1 : 0.9)
        .animation(AnimationCurves.spring.delay(delay), value: isVisible)
    }
}

#Preview {
    HowItWorksScreen(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 700)
        .background(NoirColors.charcoalGray)
}
