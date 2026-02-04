import SwiftUI

struct NoirButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case ghost
    }
    
    init(_ title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(NoirFonts.button())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(strokeColor, lineWidth: style == .ghost ? 1 : 0)
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            NoirColors.paperWhite
        case .secondary:
            NoirColors.smokeGray.opacity(0.8)
        case .ghost:
            Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return NoirColors.shadowBlack
        case .secondary, .ghost:
            return NoirColors.paperWhite
        }
    }
    
    private var strokeColor: Color {
        switch style {
        case .ghost:
            return NoirColors.glassStroke
        default:
            return .clear
        }
    }
}

struct NoirIconButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(NoirColors.paperWhite.opacity(0.8))
                .frame(width: 32, height: 32)
                .background(NoirColors.glassWhite)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        VStack(spacing: 16) {
            NoirButton("Get Started", icon: "arrow.right") {}
            NoirButton("Continue", style: .secondary) {}
            NoirButton("Learn More", style: .ghost) {}
        }
        .padding()
    }
    .frame(width: 300, height: 300)
}
