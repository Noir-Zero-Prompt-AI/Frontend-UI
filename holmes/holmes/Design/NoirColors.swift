import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
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

struct NoirColors {
    static let shadowBlack = Color(hex: "#0A0A0A")
    static let charcoalGray = Color(hex: "#1C1C1C")
    static let smokeGray = Color(hex: "#3A3A3A")
    static let fogGray = Color(hex: "#6B6B6B")
    static let paperWhite = Color(hex: "#E8E8E8")
    static let glassWhite = Color.white.opacity(0.1)
    static let glassStroke = Color.white.opacity(0.2)
    static let glassShadow = Color.black.opacity(0.4)
}
