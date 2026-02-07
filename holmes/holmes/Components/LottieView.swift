import SwiftUI
import Lottie

struct LottieView: NSViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    @Binding var play: Bool
    
    init(name: String, loopMode: LottieLoopMode = .playOnce, play: Binding<Bool> = .constant(true)) {
        self.name = name
        self.loopMode = loopMode
        self._play = play
    }
    
    func makeNSView(context: Context) -> NSView {
        let containerView = NSView()
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        context.coordinator.animationView = animationView
        
        if play {
            animationView.play()
        }
        
        return containerView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }
        
        if play {
            animationView.play { finished in
                if finished && loopMode == .playOnce {
                    DispatchQueue.main.async {
                        self.play = false
                    }
                }
            }
        } else {
            animationView.stop()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var animationView: LottieAnimationView?
    }
}
