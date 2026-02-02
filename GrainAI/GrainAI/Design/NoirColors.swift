import SwiftUI

struct NoirColors {
    // Apple Liquid Glass Theme - Darker grayscale palette
    static let shadowBlack = Color(hex: "#000000")      // Pure black
    static let charcoalGray = Color(hex: "#0D0D0D")     // Almost black bg
    static let smokeGray = Color(hex: "#1A1A1A")        // Dark gray elements
    static let fogGray = Color(hex: "#3C3C3C")          // Medium gray
    static let slateGray = Color(hex: "#8E8E93")        // Light gray (iOS system)
    static let paperWhite = Color(hex: "#FFFFFF")       // Pure white text
    static let glassWhite = Color.white.opacity(0.08)   // Subtle glass overlay
    
    // Apple-style accent colors
    static let accentBlue = Color(hex: "#007AFF")       // iOS blue
    static let systemGray = Color(hex: "#8E8E93")       // iOS system gray
    static let systemGray2 = Color(hex: "#636366")      // iOS system gray2
}

// Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
