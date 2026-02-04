import SwiftUI

struct ReadyScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let onComplete: () -> Void
    
    @State private var checkmarkScale: CGFloat = 0
    @State private var checkmarkOpacity: CGFloat = 0
    @State private var contentOpacity: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundColor(.green)
                }
                .scaleEffect(checkmarkScale)
                .opacity(checkmarkOpacity)
                
                VStack(spacing: 12) {
                    Text("You're All Set")
                        .font(NoirFonts.headline())
                        .foregroundColor(NoirColors.paperWhite)
                    
                    Text("Holmes is now learning from\nyour desktop activity")
                        .font(NoirFonts.body())
                        .foregroundColor(NoirColors.fogGray)
                        .multilineTextAlignment(.center)
                }
                .opacity(contentOpacity)
                
                Divider()
                    .background(NoirColors.smokeGray)
                    .frame(maxWidth: 300)
                    .opacity(contentOpacity)
                
                VStack(spacing: 16) {
                    Text("Quick Reference")
                        .font(NoirFonts.caption())
                        .foregroundColor(NoirColors.fogGray)
                    
                    VStack(spacing: 12) {
                        HotkeyRow(keys: "^", secondKey: "Space", description: "Search")
                        HotkeyRow(keys: "⌥", secondKey: "Space", description: "Assistant")
                        HotkeyRow(keys: "⌘", secondKey: "\\", description: "Hide/Show")
                    }
                }
                .opacity(contentOpacity)
            }
            
            Spacer()
            
            NoirButton("Start Using Holmes", icon: "sparkles") {
                viewModel.completeOnboarding()
                onComplete()
            }
            .opacity(contentOpacity)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1)) {
                checkmarkScale = 1.0
                checkmarkOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                contentOpacity = 1.0
            }
        }
    }
}

struct HotkeyRow: View {
    let keys: String
    let secondKey: String
    let description: String
    
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 4) {
                KeyCap(text: keys)
                Text("+")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(NoirColors.fogGray)
                KeyCap(text: secondKey)
            }
            
            Image(systemName: "arrow.right")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(NoirColors.fogGray)
            
            Text(description)
                .font(NoirFonts.caption())
                .foregroundColor(NoirColors.paperWhite)
        }
    }
}

struct KeyCap: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundColor(NoirColors.paperWhite)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(NoirColors.smokeGray.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(NoirColors.glassStroke, lineWidth: 1)
            )
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        ReadyScreen(viewModel: OnboardingViewModel()) {}
    }
    .frame(width: 600, height: 700)
}
