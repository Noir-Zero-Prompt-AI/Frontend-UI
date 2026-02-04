import SwiftUI

struct NoirAnimations {
    static let defaultDuration: Double = 0.3
    static let slowDuration: Double = 0.5
    static let fastDuration: Double = 0.2
    
    static var smooth: Animation {
        .easeInOut(duration: defaultDuration)
    }
    
    static var spring: Animation {
        .spring(response: 0.3, dampingFraction: 0.8)
    }
    
    static var gentleSpring: Animation {
        .spring(response: 0.4, dampingFraction: 0.7)
    }
    
    static var breathing: Animation {
        .easeInOut(duration: 3).repeatForever(autoreverses: true)
    }
    
    static var pulse: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }
    
    static var fadeIn: Animation {
        .easeOut(duration: fastDuration)
    }
    
    static var fadeOut: Animation {
        .easeIn(duration: fastDuration)
    }
}
