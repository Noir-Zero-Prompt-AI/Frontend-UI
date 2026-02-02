import SwiftUI

struct ReadyScreen: View {
    let viewModel: OnboardingViewModel
    let onComplete: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Success checkmark
            ZStack {
                Circle()
                    .stroke(NoirColors.paperWhite.opacity(0.2), lineWidth: 3)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(NoirColors.paperWhite)
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.5)
            .animation(AnimationCurves.spring.delay(0.1), value: isVisible)
            
            VStack(spacing: 12) {
                // Headline
                Text("You're All Set")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(NoirColors.paperWhite)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(AnimationCurves.spring.delay(0.2), value: isVisible)
                
                // Subhead
                Text("Grain is now learning from\nyour desktop activity")
                    .font(.system(size: 16))
                    .foregroundStyle(NoirColors.fogGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(AnimationCurves.spring.delay(0.3), value: isVisible)
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
                .frame(width: 300)
                .opacity(isVisible ? 1 : 0)
                .animation(AnimationCurves.spring.delay(0.4), value: isVisible)
            
            // Hotkey reference
            VStack(alignment: .leading, spacing: 16) {
                Text("Quick Reference:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(NoirColors.paperWhite)
                
                VStack(alignment: .leading, spacing: 12) {
                    hotkeyRow(symbol: "⌃⎵", description: "Control+Space → Search")
                    hotkeyRow(symbol: "⌥⎵", description: "Option+Space  → Assistant")
                    hotkeyRow(symbol: "⌘\\", description: "Command+\\    → Hide/Show")
                }
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(AnimationCurves.spring.delay(0.5), value: isVisible)
            
            Spacer()
            
            // Launch CTA
            NoirButton(title: "Start Using Grain", action: {
                onComplete()
            }, style: .primary)
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(AnimationCurves.spring.delay(0.6), value: isVisible)
        }
        .padding(60)
        .onAppear {
            isVisible = true
        }
    }
    
    private func hotkeyRow(symbol: String, description: String) -> some View {
        HStack(spacing: 12) {
            Text(symbol)
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(NoirColors.paperWhite)
                .frame(width: 40)
            
            Text(description)
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(NoirColors.paperWhite.opacity(0.8))
        }
    }
}

#Preview {
    ReadyScreen(viewModel: OnboardingViewModel(), onComplete: {
        print("Complete")
    })
    .frame(width: 600, height: 700)
    .background(NoirColors.charcoalGray)
}
