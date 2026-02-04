import SwiftUI

struct SearchBarView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Binding var isVisible: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            controlBar
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            mainContent
                .padding(.horizontal, 20)
                .padding(.vertical, viewModel.isListening ? 40 : 30)
        }
        .frame(width: 700, height: viewModel.isListening ? 200 : 150)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(NoirColors.glassStroke, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 40, x: 0, y: 20)
        .scaleEffect(isVisible ? 1.0 : 0.95)
        .opacity(isVisible ? 1.0 : 0)
        .animation(NoirAnimations.spring, value: isVisible)
        .onAppear {
            isTextFieldFocused = true
        }
        .onExitCommand {
            dismissSearchBar()
        }
    }
    
    private var controlBar: some View {
        HStack(spacing: 12) {
            ListenButton(isListening: viewModel.isListening) {
                if viewModel.isListening {
                    viewModel.stopListening()
                } else {
                    viewModel.startListening()
                }
            }
            
            Spacer()
            
            ControlButton(label: "Ask", shortcut: "⌘↵") {
                viewModel.submitSearch()
            }
            
            ControlButton(label: "Hide", shortcut: "⌘\\") {
                dismissSearchBar()
            }
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NoirColors.paperWhite.opacity(0.6))
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isListening {
            VoiceInputView(viewModel: viewModel)
        } else {
            NoirTextField("Ask Holmes anything...", text: $viewModel.searchText, fontSize: 40)
                .focused($isTextFieldFocused)
                .onSubmit {
                    viewModel.submitSearch()
                }
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            GrainOverlay(opacity: 0.04)
        }
    }
    
    private func dismissSearchBar() {
        viewModel.reset()
        isVisible = false
    }
}

struct ControlButton: View {
    let label: String
    let shortcut: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(label)
                Text(shortcut)
                    .foregroundColor(NoirColors.fogGray)
            }
            .font(NoirFonts.button())
            .foregroundColor(NoirColors.paperWhite.opacity(0.8))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        SearchBarView(isVisible: .constant(true))
    }
    .frame(width: 900, height: 400)
}
