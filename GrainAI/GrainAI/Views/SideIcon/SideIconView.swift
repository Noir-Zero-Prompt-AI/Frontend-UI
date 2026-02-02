import SwiftUI

enum IconState {
    case dormant    // 30% opacity
    case listening  // 70% opacity, pulse
    case thinking   // 90% opacity, processing
    case acting     // 100% opacity, execution
}

struct SideIconView: View {
    @State private var state: IconState = .dormant
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Background glow for active states
            if state != .dormant {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                NoirColors.paperWhite.opacity(0.2),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulseScale)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulseScale)
            }
            
            // Desktop assistant icon (noir.svg from Downloads)
            Image(nsImage: loadNoirIcon())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .opacity(opacityForState)
                .scaleEffect(scaleForState)
                .rotationEffect(.degrees(rotationAngle))
                .animation(AnimationCurves.standard, value: state)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .frame(width: 80, height: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            toggleMainPanel()
        }
        .onAppear {
            // Simulate state changes (for testing)
            Task {
                try? await Task.sleep(for: .seconds(2))
                state = .listening
                pulseScale = 1.1
                
                try? await Task.sleep(for: .seconds(2))
                state = .thinking
                startThinkingAnimation()
                
                try? await Task.sleep(for: .seconds(2))
                state = .acting
                
                try? await Task.sleep(for: .seconds(2))
                state = .dormant
            }
        }
    }
    
    var opacityForState: Double {
        switch state {
        case .dormant: 0.3
        case .listening: 0.7
        case .thinking: 0.9
        case .acting: 1.0
        }
    }
    
    var scaleForState: Double {
        switch state {
        case .dormant: 1.0
        case .listening: 1.0
        case .thinking: 1.0
        case .acting: 1.1
        }
    }
    
    private func startThinkingAnimation() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
    
    private func toggleMainPanel() {
        NotificationCenter.default.post(name: .toggleSidePanel, object: nil)
    }
    
    private func loadNoirIcon() -> NSImage {
        // Try to load from Downloads folder
        let downloadsPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Downloads")
            .appendingPathComponent("noir-icon.png")
        
        if let image = NSImage(contentsOf: downloadsPath) {
            return image
        }
        
        // Fallback to bundled asset
        if let image = NSImage(named: "noir-icon") {
            return image
        }
        
        // Final fallback: system icon
        return NSImage(systemSymbolName: "person.fill.badge.sparkles", accessibilityDescription: "AI Assistant") ?? NSImage()
    }
}

#Preview {
    SideIconView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [NoirColors.charcoalGray, NoirColors.shadowBlack],
                startPoint: .top,
                endPoint: .bottom
            )
        )
}
