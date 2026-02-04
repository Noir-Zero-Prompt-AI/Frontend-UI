import SwiftUI

struct HowItWorksScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var cardsOpacity: CGFloat = 0
    @State private var cardsOffset: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 40) {
                Text("How Holmes Works")
                    .font(NoirFonts.headline())
                    .foregroundColor(NoirColors.paperWhite)
                
                HStack(spacing: 24) {
                    FeatureCard(
                        icon: "command",
                        shortcut: "^Space",
                        title: "Search",
                        description: "Control+Space\nfor quick commands"
                    )
                    
                    FeatureCard(
                        icon: "option",
                        shortcut: "⌥Space",
                        title: "Assistant",
                        description: "Option+Space\nfor full panel"
                    )
                    
                    FeatureCard(
                        icon: "bolt.fill",
                        shortcut: "Auto",
                        title: "Automatic",
                        description: "I learn patterns\nand act for you"
                    )
                }
                .opacity(cardsOpacity)
                .offset(y: cardsOffset)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                NoirButton("Back", style: .ghost) {
                    viewModel.previousStep()
                }
                
                NoirButton("Continue", icon: "arrow.right") {
                    viewModel.nextStep()
                }
            }
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                cardsOpacity = 1.0
                cardsOffset = 0
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let shortcut: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(NoirColors.smokeGray.opacity(0.5))
                    .frame(width: 80, height: 80)
                
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .light))
                        .foregroundColor(NoirColors.paperWhite)
                    
                    Text(shortcut)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(NoirColors.fogGray)
                }
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(NoirFonts.title())
                    .foregroundColor(NoirColors.paperWhite)
                
                Text(description)
                    .font(NoirFonts.caption())
                    .foregroundColor(NoirColors.fogGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .frame(width: 140)
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        HowItWorksScreen(viewModel: OnboardingViewModel())
    }
    .frame(width: 600, height: 700)
}
