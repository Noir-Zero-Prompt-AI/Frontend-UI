import SwiftUI

struct MainPanelView: View {
    @State private var contextText = "I noticed you're working on the Q4 presentation..."
    @State private var suggestions = [
        "Format charts consistently",
        "Update revenue projections",
        "Check spelling & grammar"
    ]
    @State private var recentActivities = [
        Activity(icon: "doc.text.fill", description: "Renamed 3 files", timeAgo: "2m ago"),
        Activity(icon: "tablecells.fill", description: "Updated Excel formulas", timeAgo: "8m ago"),
        Activity(icon: "folder.fill", description: "Organized downloads folder", timeAgo: "15m ago")
    ]
    @State private var showActivities = true
    
    var body: some View {
        ZStack {
            // Apple Liquid Glass background - darker
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.12),
                                    Color.white.opacity(0.04)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.6), radius: 50, x: 0, y: 25)
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Context awareness card
                        contextCard
                        
                        // Suggested actions
                        suggestionsSection
                        
                        // Recent activity
                        recentActivitySection
                    }
                    .padding(20)
                }
            }
        }
        .frame(width: 400, height: 600)
    }
    
    private var headerView: some View {
        HStack {
            // Detective icon placeholder
            Image(systemName: "person.fill.viewfinder")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(NoirColors.paperWhite)
            
            Text("Grain")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(NoirColors.paperWhite)
            
            Spacer()
            
            // Close button
            Button(action: dismissPanel) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
    }
    
    private var contextCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Context Detected", systemImage: "chart.bar.fill")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(NoirColors.systemGray)
            
            Text(contextText)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.95))
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.03))
        .clipShape(.rect(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }
    
    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                Text("I can help with:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            VStack(spacing: 10) {
                ForEach(suggestions, id: \.self) { suggestion in
                    suggestionRow(suggestion)
                }
            }
            
            HStack(spacing: 12) {
                NoirButton(title: "Approve All", action: approveAll, style: .primary)
                NoirButton(title: "Customize", action: customize, style: .ghost)
            }
            .padding(.top, 8)
        }
    }
    
    private func suggestionRow(_ suggestion: String) -> some View {
        Button(action: {
            executeSuggestion(suggestion)
        }) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                
                Text(suggestion)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.85))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color.white.opacity(0.02))
        .clipShape(.rect(cornerRadius: 8))
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { showActivities.toggle() }) {
                HStack {
                    Text("Recent Activity")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Image(systemName: showActivities ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .buttonStyle(.plain)
            
            if showActivities {
                VStack(spacing: 8) {
                    ForEach(recentActivities) { activity in
                        activityRow(activity)
                    }
                }
            }
        }
    }
    
    private func activityRow(_ activity: Activity) -> some View {
        HStack(spacing: 12) {
            Image(systemName: activity.icon)
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 24, height: 24)
                .background(Color.white.opacity(0.05))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.85))
                
                Text(activity.timeAgo)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // Actions
    private func dismissPanel() {
        NotificationCenter.default.post(name: .toggleSidePanel, object: nil)
    }
    
    private func approveAll() {
        print("Approving all suggestions")
    }
    
    private func customize() {
        print("Customize suggestions")
    }
    
    private func executeSuggestion(_ suggestion: String) {
        print("Executing: \(suggestion)")
    }
}

struct Activity: Identifiable {
    let id = UUID()
    let icon: String
    let description: String
    let timeAgo: String
}

#Preview {
    MainPanelView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
