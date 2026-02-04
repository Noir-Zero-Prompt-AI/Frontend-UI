import SwiftUI

struct ActionSuggestions: View {
    let suggestions: [ActionSuggestion]
    let onSelect: (ActionSuggestion) -> Void
    let onApproveAll: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.yellow.opacity(0.8))
                
                Text("I can help with:")
                    .font(NoirFonts.caption())
                    .foregroundColor(NoirColors.fogGray)
            }
            
            VStack(spacing: 8) {
                ForEach(suggestions) { suggestion in
                    ActionRow(suggestion: suggestion) {
                        onSelect(suggestion)
                    }
                }
            }
            
            HStack(spacing: 12) {
                NoirButton("Approve All", icon: "checkmark.circle", style: .secondary) {
                    onApproveAll()
                }
                
                NoirButton("Customize", style: .ghost) {}
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(NoirColors.smokeGray.opacity(0.2))
        )
    }
}

struct ActionRow: View {
    let suggestion: ActionSuggestion
    let onTap: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(suggestion.isSelected ? Color.green : NoirColors.fogGray, lineWidth: 1.5)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .opacity(suggestion.isSelected ? 1 : 0)
                    )
                
                Text(suggestion.title)
                    .font(NoirFonts.body())
                    .foregroundColor(NoirColors.paperWhite)
                
                Spacer()
                
                if isHovered {
                    Image(systemName: "arrow.right.circle")
                        .font(.system(size: 14))
                        .foregroundColor(NoirColors.fogGray)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isHovered ? NoirColors.smokeGray.opacity(0.3) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

struct ActionSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let action: String
    var isSelected: Bool = false
    
    static let samples: [ActionSuggestion] = [
        ActionSuggestion(title: "Auto-sum columns A-D", action: "excel_sum"),
        ActionSuggestion(title: "Format as currency", action: "format_currency"),
        ActionSuggestion(title: "Create revenue chart", action: "create_chart")
    ]
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        ActionSuggestions(
            suggestions: ActionSuggestion.samples,
            onSelect: { _ in },
            onApproveAll: {}
        )
        .padding()
    }
    .frame(width: 400, height: 400)
}
