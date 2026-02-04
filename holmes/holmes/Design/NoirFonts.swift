import SwiftUI

struct NoirFonts {
    static func displayLarge() -> Font {
        .system(size: 48, weight: .light, design: .default)
    }
    
    static func displayMedium() -> Font {
        .system(size: 32, weight: .regular, design: .default)
    }
    
    static func headline() -> Font {
        .system(size: 24, weight: .semibold, design: .rounded)
    }
    
    static func title() -> Font {
        .system(size: 20, weight: .medium, design: .default)
    }
    
    static func body() -> Font {
        .system(size: 16, weight: .regular, design: .default)
    }
    
    static func caption() -> Font {
        .system(size: 14, weight: .regular, design: .default)
    }
    
    static func mono() -> Font {
        .system(size: 14, weight: .regular, design: .monospaced)
    }
    
    static func button() -> Font {
        .system(size: 14, weight: .medium, design: .default)
    }
}
