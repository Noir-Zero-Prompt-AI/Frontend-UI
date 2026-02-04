import SwiftUI

struct GlassCard<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content
    
    init(cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                    
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(NoirColors.glassStroke, lineWidth: 1.5)
            )
            .shadow(color: NoirColors.glassShadow, radius: 30, x: 0, y: 20)
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct HeavyGlassBackground: View {
    var cornerRadius: CGFloat = 24
    
    var body: some View {
        ZStack {
            VisualEffectBlur(material: .fullScreenUI, blendingMode: .behindWindow)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(NoirColors.glassStroke, lineWidth: 1.5)
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        GlassCard {
            VStack {
                Text("Holmes")
                    .font(NoirFonts.headline())
                    .foregroundColor(NoirColors.paperWhite)
                Text("Zero Prompt AI")
                    .font(NoirFonts.body())
                    .foregroundColor(NoirColors.fogGray)
            }
            .padding(40)
        }
    }
    .frame(width: 400, height: 300)
}
