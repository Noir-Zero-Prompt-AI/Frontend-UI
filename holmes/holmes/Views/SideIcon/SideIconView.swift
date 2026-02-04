import SwiftUI

enum IconState: Equatable {
    case dormant
    case listening
    case thinking
    case acting
    
    var opacity: CGFloat {
        switch self {
        case .dormant: return 0.4
        case .listening: return 0.7
        case .thinking: return 0.9
        case .acting: return 1.0
        }
    }
}

struct SideIconView: View {
    @Binding var state: IconState
    @Binding var isExpanded: Bool
    let onTap: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                backgroundGlow
                
                iconContent
                    .scaleEffect(pulseScale)
            }
            .frame(width: 56, height: 56)
        }
        .buttonStyle(.plain)
        .opacity(state.opacity)
        .onAppear {
            startAnimations()
        }
        .onChange(of: state) { oldState, newState in
            startAnimations()
        }
    }
    
    private var backgroundGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        glowColor.opacity(0.3),
                        glowColor.opacity(0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 10,
                    endRadius: 35
                )
            )
            .blur(radius: 8)
    }
    
    private var iconContent: some View {
        ZStack {
            Circle()
                .fill(NoirColors.charcoalGray)
                .overlay(
                    Circle()
                        .stroke(NoirColors.glassStroke, lineWidth: 1)
                )
            
            Image(systemName: iconName)
                .font(.system(size: 24, weight: .light))
                .foregroundColor(NoirColors.paperWhite)
                .rotationEffect(.degrees(state == .thinking ? rotationAngle : 0))
        }
    }
    
    private var iconName: String {
        switch state {
        case .dormant: return "magnifyingglass"
        case .listening: return "waveform"
        case .thinking: return "gearshape"
        case .acting: return "bolt.fill"
        }
    }
    
    private var glowColor: Color {
        switch state {
        case .dormant: return NoirColors.fogGray
        case .listening: return Color.blue
        case .thinking: return Color.orange
        case .acting: return Color.green
        }
    }
    
    private func startAnimations() {
        withAnimation(.default) {
            pulseScale = 1.0
            rotationAngle = 0
        }
        
        switch state {
        case .dormant:
            break
        case .listening:
            withAnimation(NoirAnimations.pulse) {
                pulseScale = 1.1
            }
        case .thinking:
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        case .acting:
            withAnimation(.easeInOut(duration: 0.3).repeatCount(3)) {
                pulseScale = 1.15
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()
        
        HStack(spacing: 40) {
            VStack {
                SideIconView(state: .constant(.dormant), isExpanded: .constant(false)) {}
                Text("Dormant").font(.caption)
            }
            VStack {
                SideIconView(state: .constant(.listening), isExpanded: .constant(false)) {}
                Text("Listening").font(.caption)
            }
            VStack {
                SideIconView(state: .constant(.thinking), isExpanded: .constant(false)) {}
                Text("Thinking").font(.caption)
            }
            VStack {
                SideIconView(state: .constant(.acting), isExpanded: .constant(false)) {}
                Text("Acting").font(.caption)
            }
        }
    }
    .frame(width: 500, height: 200)
}
