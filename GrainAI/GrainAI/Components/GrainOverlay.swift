import SwiftUI

struct GrainOverlay: View {
    var opacity: Double = 0.08
    
    var body: some View {
        // Create a noise pattern programmatically
        Rectangle()
            .fill(
                ImagePaint(
                    image: Image(systemName: "circle.fill")
                        .renderingMode(.template),
                    scale: 0.02
                )
            )
            .blendMode(.overlay)
            .opacity(opacity)
            .allowsHitTesting(false)
    }
}

// Alternative: Using a repeating pattern
struct FilmGrainOverlay: View {
    var opacity: Double = 0.08
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                // Generate random grain pattern
                let dotSize: CGFloat = 1
                let spacing: CGFloat = 2
                
                for x in stride(from: 0, to: size.width, by: spacing) {
                    for y in stride(from: 0, to: size.height, by: spacing) {
                        if Double.random(in: 0...1) > 0.5 {
                            let rect = CGRect(x: x, y: y, width: dotSize, height: dotSize)
                            context.fill(
                                Path(ellipseIn: rect),
                                with: .color(.white.opacity(Double.random(in: 0.1...0.3)))
                            )
                        }
                    }
                }
            }
            .blendMode(.overlay)
            .opacity(opacity)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [NoirColors.charcoalGray, NoirColors.shadowBlack],
            startPoint: .top,
            endPoint: .bottom
        )
        
        FilmGrainOverlay()
        
        Text("Grain Effect Preview")
            .font(.system(size: 32, weight: .bold))
            .foregroundStyle(.white)
    }
}
