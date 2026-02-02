import SwiftUI

struct NotchView: View {
    @State private var isActive = false
    @State private var progress: Double = 0.0
    @State private var taskName = ""
    @State private var breathingPhase: CGFloat = 0
    
    var body: some View {
        Group {
            if NotchDetector.hasNotch() {
                if isActive {
                    activeState
                        .transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    idleState
                        .transition(.opacity)
                }
            } else {
                EmptyView()  // Graceful fallback for non-notch Macs
            }
        }
        .onAppear {
            startBreathingAnimation()
            simulateActivity()
        }
    }
    
    private var idleState: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .clear,
                        NoirColors.glassWhite.opacity(breathingPhase),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 200, height: 30)
            .clipShape(.rect(cornerRadius: 20))
            .overlay(
                FilmGrainOverlay(opacity: 0.15)
            )
    }
    
    private var activeState: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .symbolEffect(.pulse)
                    .foregroundStyle(.white)
                
                Text(taskName)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            ProgressView(value: progress)
                .tint(NoirColors.paperWhite)
                .frame(width: 200)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .background(Color.black.opacity(0.3))
        .clipShape(.rect(cornerRadius: 12))
        .frame(maxWidth: 300)
    }
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            breathingPhase = 1.0
        }
    }
    
    private func simulateActivity() {
        // Simulate task execution for demo
        Task {
            try? await Task.sleep(for: .seconds(5))
            
            isActive = true
            taskName = "Organizing files..."
            
            // Animate progress
            for i in 0...10 {
                progress = Double(i) / 10.0
                try? await Task.sleep(for: .milliseconds(200))
            }
            
            try? await Task.sleep(for: .seconds(1))
            isActive = false
            progress = 0
            taskName = ""
        }
    }
}

#Preview {
    VStack {
        Text("Notch Animation Preview")
            .font(.title)
        
        if NotchDetector.hasNotch() {
            Text("✓ Notch detected")
                .foregroundStyle(.green)
        } else {
            Text("✗ No notch detected")
                .foregroundStyle(.red)
        }
        
        NotchView()
            .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(NoirColors.charcoalGray)
}
