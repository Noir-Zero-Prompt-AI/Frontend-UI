import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content
    var cornerRadius: CGFloat = 24
    var useDarkTint: Bool = true
    
    var body: some View {
        content
            .background(.ultraThickMaterial)
            .background(
                Group {
                    if useDarkTint {
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .clipShape(.rect(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 20)
    }
}

// Preview
#Preview {
    VStack(spacing: 20) {
        GlassCard {
            VStack {
                Text("Heavy Glass Card")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                Text("This is a glass morphism container")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(32)
        }
        .frame(width: 400, height: 200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
