import SwiftUI

struct NoirFonts {
    // Professional, readable, detective-noir vibe
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, design: .default)
    }
    
    static func headline(_ size: CGFloat = 18) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    static func title(_ size: CGFloat = 32) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }
    
    static func monospaced(_ size: CGFloat = 14) -> Font {
        .system(size: size, design: .monospaced)
    }
    
    static func display(_ size: CGFloat = 52) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}
