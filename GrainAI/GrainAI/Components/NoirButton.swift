import SwiftUI

struct NoirButton: View {
    let title: String
    let action: () -> Void
    var style: NoirButtonStyle = .primary
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(style.foregroundColor)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(style.backgroundColor)
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style.borderColor, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

enum NoirButtonStyle {
    case primary
    case secondary
    case ghost
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return NoirColors.paperWhite.opacity(0.15)
        case .secondary:
            return NoirColors.smokeGray.opacity(0.5)
        case .ghost:
            return .clear
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return NoirColors.paperWhite
        case .secondary:
            return NoirColors.paperWhite.opacity(0.8)
        case .ghost:
            return NoirColors.paperWhite.opacity(0.7)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary:
            return Color.white.opacity(0.3)
        case .secondary:
            return Color.white.opacity(0.2)
        case .ghost:
            return Color.white.opacity(0.15)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NoirButton(title: "Primary Button", action: {}, style: .primary)
        NoirButton(title: "Secondary Button", action: {}, style: .secondary)
        NoirButton(title: "Ghost Button", action: {}, style: .ghost)
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(NoirColors.charcoalGray)
}
