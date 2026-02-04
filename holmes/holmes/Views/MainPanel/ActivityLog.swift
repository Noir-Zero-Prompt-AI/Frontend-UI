import SwiftUI

struct ActivityLog: View {
    let activities: [ActivityItem]
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(NoirAnimations.smooth) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Recent Activity")
                        .font(NoirFonts.caption())
                        .foregroundColor(NoirColors.fogGray)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(NoirColors.fogGray)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Divider()
                    .background(NoirColors.smokeGray)
                
                VStack(spacing: 0) {
                    ForEach(activities) { activity in
                        ActivityRow(activity: activity)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(NoirColors.smokeGray.opacity(0.2))
        )
    }
}

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(activity.statusColor)
                .frame(width: 6, height: 6)
            
            Text(activity.description)
                .font(NoirFonts.caption())
                .foregroundColor(NoirColors.paperWhite.opacity(0.8))
                .lineLimit(1)
            
            Spacer()
            
            Text(activity.timeAgo)
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundColor(NoirColors.fogGray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let description: String
    let timeAgo: String
    let status: ActivityStatus
    
    var statusColor: Color {
        switch status {
        case .completed: return .green
        case .pending: return .orange
        case .failed: return .red
        }
    }
    
    enum ActivityStatus {
        case completed
        case pending
        case failed
    }
    
    static let samples: [ActivityItem] = [
        ActivityItem(description: "Renamed 5 files in Downloads", timeAgo: "2m ago", status: .completed),
        ActivityItem(description: "Organized desktop icons", timeAgo: "8m ago", status: .completed),
        ActivityItem(description: "Updated Excel formulas", timeAgo: "15m ago", status: .completed),
        ActivityItem(description: "Backed up documents", timeAgo: "1h ago", status: .completed)
    ]
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        ActivityLog(activities: ActivityItem.samples)
            .padding()
    }
    .frame(width: 400, height: 400)
}
