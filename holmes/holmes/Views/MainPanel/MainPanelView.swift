import SwiftUI

struct MainPanelView: View {
    @Binding var isVisible: Bool
    @State private var context: DetectedContext = .placeholder
    @State private var suggestions: [ActionSuggestion] = ActionSuggestion.samples
    @State private var activities: [ActivityItem] = ActivityItem.samples
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                VStack(spacing: 16) {
                    ContextCard(context: context)
                    
                    ActionSuggestions(
                        suggestions: suggestions,
                        onSelect: { suggestion in
                            selectSuggestion(suggestion)
                        },
                        onApproveAll: {
                            approveAllSuggestions()
                        }
                    )
                    
                    ActivityLog(activities: activities)
                }
                .padding(16)
            }
        }
        .frame(width: 380, height: 520)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(NoirColors.glassStroke, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 30, x: 0, y: 15)
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(NoirColors.paperWhite)
                    .rotationEffect(.degrees(-45))
                
                Text("Holmes")
                    .font(NoirFonts.title())
                    .foregroundColor(NoirColors.paperWhite)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                WindowButton(icon: "minus") {
                    isVisible = false
                }
                
                WindowButton(icon: "xmark") {
                    isVisible = false
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            NoirColors.charcoalGray.opacity(0.5)
        )
    }
    
    private var glassBackground: some View {
        ZStack {
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.35),
                    Color.black.opacity(0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            GrainOverlay(opacity: 0.04)
        }
    }
    
    private func selectSuggestion(_ suggestion: ActionSuggestion) {
        if let index = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
            suggestions[index].isSelected.toggle()
        }
    }
    
    private func approveAllSuggestions() {
        for index in suggestions.indices {
            suggestions[index].isSelected = true
        }
    }
}

struct WindowButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(NoirColors.paperWhite.opacity(0.6))
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(isHovered ? NoirColors.smokeGray : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        MainPanelView(isVisible: .constant(true))
    }
    .frame(width: 500, height: 600)
}
