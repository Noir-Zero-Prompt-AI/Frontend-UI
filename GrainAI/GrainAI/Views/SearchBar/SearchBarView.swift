import SwiftUI

struct SearchBarView: View {
    @State private var searchText = ""
    @State private var isListening = false
    @State private var isVisible = false
    @State private var currentPlaceholder = 0
    @FocusState private var isFocused: Bool
    
    // Rotating placeholder suggestions
    let placeholders = [
        "Ask me anything...",
        "Search files and apps...",
        "Set a reminder...",
        "Send an email...",
        "Open a website...",
        "Calculate something...",
        "Find a document...",
        "Create a note...",
        "Schedule a meeting...",
        "Play music..."
    ]
    
    var body: some View {
        ZStack {
            // Apple Liquid Glass background
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 20)
            
            VStack(spacing: 12) {
                // Large text input field with rotating placeholder
                TextField("", text: $searchText, prompt: Text(placeholders[currentPlaceholder])
                    .foregroundStyle(Color.white.opacity(0.3)))
                    .font(.system(size: 48, weight: .regular, design: .default))
                    .foregroundStyle(.white.opacity(0.95))
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 40)
                    .focused($isFocused)
                    .onSubmit {
                        handleSubmit()
                    }
                
                // Listening visualization
                if isListening {
                    HStack(spacing: 4) {
                        ForEach(0..<7) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.6))
                                .frame(width: 3, height: CGFloat.random(in: 10...30))
                                .animation(
                                    .easeInOut(duration: 0.4)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.1),
                                    value: isListening
                                )
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(width: 800, height: isListening ? 180 : 150)
        .scaleEffect(isVisible ? 1.0 : 0.95)
        .opacity(isVisible ? 1.0 : 0)
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isVisible)
        .onAppear {
            isVisible = true
            isFocused = true
            startPlaceholderRotation()
        }
    }
    
    private func startPlaceholderRotation() {
        // Rotate placeholders every 3 seconds
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPlaceholder = (currentPlaceholder + 1) % placeholders.count
            }
        }
    }
    
    private func handleSubmit() {
        guard !searchText.isEmpty else { return }
        
        print("Processing query: \(searchText)")
        
        // Process the search query
        // For now, just clear and dismiss
        searchText = ""
        dismissSearchBar()
    }
    
    private func dismissSearchBar() {
        NotificationCenter.default.post(name: .hideSearchBar, object: nil)
    }
}

#Preview {
    SearchBarView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
