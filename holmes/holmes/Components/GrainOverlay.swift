import SwiftUI

struct GrainOverlay: View {
    @State private var phase: CGFloat = 0
    let opacity: CGFloat
    let animated: Bool
    
    init(opacity: CGFloat = 0.08, animated: Bool = false) {
        self.opacity = opacity
        self.animated = animated
    }
    
    var body: some View {
        Canvas { context, size in
            for _ in 0..<Int(size.width * size.height * 0.03) {
                let x = CGFloat.random(in: 0..<size.width)
                let y = CGFloat.random(in: 0..<size.height)
                let grainOpacity = Double.random(in: 0.1...0.3)
                
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                    with: .color(Color.white.opacity(grainOpacity))
                )
            }
        }
        .opacity(opacity)
        .blendMode(.overlay)
        .allowsHitTesting(false)
        .id(animated ? phase : 0)
        .onAppear {
            if animated {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    phase = CGFloat.random(in: 0...1000)
                }
            }
        }
    }
}

struct FilmGrainModifier: ViewModifier {
    let opacity: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay(GrainOverlay(opacity: opacity))
    }
}

extension View {
    func filmGrain(opacity: CGFloat = 0.08) -> some View {
        modifier(FilmGrainModifier(opacity: opacity))
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray
            .ignoresSafeArea()
        
        VStack {
            Text("Film Grain Effect")
                .font(NoirFonts.headline())
                .foregroundColor(NoirColors.paperWhite)
        }
    }
    .filmGrain()
    .frame(width: 400, height: 300)
}
