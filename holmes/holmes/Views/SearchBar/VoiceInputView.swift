import SwiftUI

struct VoiceInputView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            AudioWaveform(level: viewModel.audioLevel)
                .frame(height: 60)
                .padding(.horizontal, 40)
            
            Text(viewModel.searchText.isEmpty ? "Listening..." : viewModel.searchText)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(NoirColors.paperWhite)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 20)
        }
    }
}

struct AudioWaveform: View {
    let level: CGFloat
    @State private var bars: [CGFloat] = Array(repeating: 0.2, count: 20)
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<20, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(NoirColors.paperWhite.opacity(0.8))
                    .frame(width: 4, height: bars[index] * 60)
            }
        }
        .onChange(of: level) { oldLevel, newLevel in
            withAnimation(.easeInOut(duration: 0.1)) {
                for i in 0..<bars.count {
                    let randomVariation = CGFloat.random(in: 0.5...1.5)
                    bars[i] = max(0.1, min(1.0, newLevel * randomVariation))
                }
            }
        }
    }
}

struct ListenButton: View {
    let isListening: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isListening {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                    Text("Listening...")
                } else {
                    Image(systemName: "waveform")
                        .font(.system(size: 12, weight: .medium))
                    Text("Listen")
                }
            }
            .font(NoirFonts.button())
            .foregroundColor(isListening ? Color.red : NoirColors.paperWhite.opacity(0.8))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isListening ? Color.red.opacity(0.2) : NoirColors.glassWhite)
            )
            .overlay(
                Capsule()
                    .stroke(isListening ? Color.red.opacity(0.5) : NoirColors.glassStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        VStack(spacing: 40) {
            VoiceInputView(viewModel: SearchViewModel())
            
            HStack {
                ListenButton(isListening: false) {}
                ListenButton(isListening: true) {}
            }
        }
        .padding()
    }
    .frame(width: 600, height: 400)
}
