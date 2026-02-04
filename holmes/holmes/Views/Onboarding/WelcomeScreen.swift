import SwiftUI

struct WelcomeScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var iconScale: CGFloat = 0.8
    @State private var iconOpacity: CGFloat = 0
    @State private var textOpacity: CGFloat = 0
    @State private var buttonOpacity: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(NoirColors.smokeGray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 56, weight: .thin))
                        .foregroundColor(NoirColors.paperWhite)
                        .rotationEffect(.degrees(-45))
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)
                
                VStack(spacing: 12) {
                    Text("holmes")
                        .font(.system(size: 48, weight: .light, design: .default))
                        .foregroundColor(NoirColors.paperWhite)
                        .tracking(4)
                    
                    Text("Zero Prompt AI for macOS")
                        .font(NoirFonts.body())
                        .foregroundColor(NoirColors.fogGray)
                }
                .opacity(textOpacity)
                
                Text("I learn from your actions and help\nbefore you even ask.")
                    .font(NoirFonts.body())
                    .foregroundColor(NoirColors.paperWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(textOpacity)
            }
            
            Spacer()
            
            NoirButton("Get Started", icon: "arrow.right") {
                viewModel.nextStep()
            }
            .opacity(buttonOpacity)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                textOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
                buttonOpacity = 1.0
            }
        }
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        WelcomeScreen(viewModel: OnboardingViewModel())
    }
    .frame(width: 600, height: 700)
}
