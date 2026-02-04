import SwiftUI

struct PermissionsScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var cardsOpacity: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                Text("Permissions Needed")
                    .font(NoirFonts.headline())
                    .foregroundColor(NoirColors.paperWhite)
                
                VStack(spacing: 16) {
                    PermissionCard(
                        icon: "rectangle.dashed.badge.record",
                        title: "Screen Recording",
                        description: "To understand what you're working on and provide contextual help",
                        isGranted: viewModel.hasScreenRecordingPermission,
                        action: viewModel.openScreenRecordingSettings
                    )
                    
                    PermissionCard(
                        icon: "accessibility",
                        title: "Accessibility",
                        description: "To interact with apps on your behalf (clicking, typing, etc)",
                        isGranted: viewModel.hasAccessibilityPermission,
                        action: viewModel.requestAccessibilityPermission
                    )
                    
                    PermissionCard(
                        icon: "gearshape.2.fill",
                        title: "Automation",
                        description: "To execute tasks across multiple applications automatically",
                        isGranted: viewModel.hasAutomationPermission,
                        action: viewModel.openAutomationSettings
                    )
                }
                .opacity(cardsOpacity)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                NoirButton("Back", style: .ghost) {
                    viewModel.previousStep()
                }
                
                NoirButton(
                    viewModel.allPermissionsGranted ? "Continue" : "Grant Permissions",
                    icon: viewModel.allPermissionsGranted ? "arrow.right" : "lock.open.fill"
                ) {
                    if viewModel.allPermissionsGranted {
                        viewModel.nextStep()
                    } else {
                        if !viewModel.hasAccessibilityPermission {
                            viewModel.requestAccessibilityPermission()
                        } else if !viewModel.hasScreenRecordingPermission {
                            viewModel.openScreenRecordingSettings()
                        }
                    }
                }
            }
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.checkPermissions()
            withAnimation(.easeOut(duration: 0.5)) {
                cardsOpacity = 1.0
            }
        }
    }
}

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let isGranted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isGranted ? Color.green.opacity(0.2) : NoirColors.smokeGray.opacity(0.5))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: isGranted ? "checkmark" : icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isGranted ? .green : NoirColors.paperWhite)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(NoirFonts.title())
                        .foregroundColor(NoirColors.paperWhite)
                    
                    Text(description)
                        .font(NoirFonts.caption())
                        .foregroundColor(NoirColors.fogGray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if !isGranted {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(NoirColors.fogGray)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(NoirColors.smokeGray.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isGranted ? Color.green.opacity(0.3) : NoirColors.glassStroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: 450)
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        PermissionsScreen(viewModel: OnboardingViewModel())
    }
    .frame(width: 600, height: 700)
}
