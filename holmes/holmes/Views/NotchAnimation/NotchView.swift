import SwiftUI
import Foundation

struct NotchView: View {
    @ObservedObject var viewModel: NotchViewModel
    let onTap: () -> Void
    
    var body: some View {
        if viewModel.hasNotch {
            notchContent
                .onAppear {
                    viewModel.startIdleAnimation()
                }
                .onDisappear {
                    viewModel.stopIdleAnimation()
                }
        }
    }
    
    @ViewBuilder
    private var notchContent: some View {
        switch viewModel.state {
        case .idle:
            IdleNotchView(
                breathingPhase: viewModel.breathingPhase,
                isHovered: viewModel.isHovered,
                onTap: onTap
            )
            .onHover { hovering in
                viewModel.isHovered = hovering
            }
            
        case .active(let taskName, let progress):
            ActiveNotchView(
                taskName: taskName,
                progress: progress,
                onTap: onTap
            )
            
        case .expanded:
            ExpandedNotchView(
                onCollapse: { viewModel.collapse() },
                onTap: onTap
            )
        }
    }
}

struct IdleNotchView: View {
    let breathingPhase: CGFloat
    let isHovered: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                NoirColors.glassWhite.opacity(0.5 + Darwin.sin(Double(breathingPhase)) * 0.2),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 200, height: 30)
                    .opacity(isHovered ? 0.8 : 0.4)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ActiveNotchView: View {
    let taskName: String
    let progress: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.yellow)
                    
                    Text(taskName)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(NoirColors.paperWhite)
                        .lineLimit(1)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(NoirColors.smokeGray)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(NoirColors.paperWhite)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: 280)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(NoirColors.charcoalGray.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(NoirColors.glassStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct ExpandedNotchView: View {
    let onCollapse: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Holmes")
                    .font(NoirFonts.caption())
                    .foregroundStyle(NoirColors.paperWhite)
                
                Spacer()
                
                Button(action: onCollapse) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(NoirColors.fogGray)
                }
                .buttonStyle(.plain)
            }
            
            HStack(spacing: 16) {
                QuickActionButton(icon: "pause.fill", label: "Pause") {}
                QuickActionButton(icon: "gearshape.fill", label: "Settings") {}
                QuickActionButton(icon: "questionmark.circle.fill", label: "Help") {}
            }
        }
        .padding(16)
        .frame(maxWidth: 320)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(NoirColors.charcoalGray.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(NoirColors.glassStroke, lineWidth: 1)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(NoirColors.paperWhite)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(NoirColors.fogGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(NoirColors.smokeGray.opacity(0.3))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 40) {
            IdleNotchView(breathingPhase: 0, isHovered: false) {}
            ActiveNotchView(taskName: "Organizing files...", progress: 0.65) {}
            ExpandedNotchView(onCollapse: {}) {}
        }
        .padding()
    }
    .frame(width: 400, height: 500)
}
