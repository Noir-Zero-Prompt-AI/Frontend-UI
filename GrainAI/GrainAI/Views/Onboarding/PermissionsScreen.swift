import SwiftUI

struct PermissionsScreen: View {
    let viewModel: OnboardingViewModel
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            Text("Permissions Needed")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(NoirColors.paperWhite)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : -20)
                .animation(AnimationCurves.spring.delay(0.1), value: isVisible)
            
            // Permission cards
            VStack(spacing: 16) {
                permissionCard(
                    icon: "display",
                    title: "Screen Recording",
                    description: "To understand what you're working on and provide contextual help",
                    isGranted: viewModel.permissionsManager.hasScreenRecording,
                    permissionType: .screenRecording,
                    delay: 0.2
                )
                
                permissionCard(
                    icon: "hand.tap.fill",
                    title: "Accessibility",
                    description: "To interact with apps on your behalf (clicking, typing, etc)",
                    isGranted: viewModel.permissionsManager.hasAccessibility,
                    permissionType: .accessibility,
                    delay: 0.3
                )
                
                permissionCard(
                    icon: "gearshape.2.fill",
                    title: "Automation",
                    description: "To execute tasks across multiple applications automatically",
                    isGranted: viewModel.permissionsManager.hasAutomation,
                    permissionType: .automation,
                    delay: 0.4
                )
            }
            
            Spacer()
            
            // Navigation
            VStack(spacing: 12) {
                NoirButton(
                    title: viewModel.canProceed ? "Continue" : "Grant Permissions",
                    action: {
                        if viewModel.canProceed {
                            viewModel.next()
                        } else {
                            requestAllPermissions()
                        }
                    },
                    style: .primary
                )
                
                HStack(spacing: 16) {
                    NoirButton(title: "Back", action: {
                        viewModel.previous()
                    }, style: .ghost)
                    
                    if !viewModel.canProceed {
                        Button("Check Status") {
                            viewModel.permissionsManager.checkAllPermissions()
                        }
                        .font(.system(size: 13))
                        .foregroundStyle(NoirColors.fogGray)
                        .buttonStyle(.plain)
                    }
                }
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(AnimationCurves.spring.delay(0.5), value: isVisible)
        }
        .padding(60)
        .onAppear {
            isVisible = true
            viewModel.permissionsManager.checkAllPermissions()
        }
    }
    
    private func permissionCard(
        icon: String,
        title: String,
        description: String,
        isGranted: Bool,
        permissionType: PermissionType,
        delay: Double
    ) -> some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(NoirColors.paperWhite)
                .frame(width: 50, height: 50)
                .background(NoirColors.smokeGray.opacity(0.3))
                .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(NoirColors.paperWhite)
                    
                    Spacer()
                    
                    // Status indicator
                    if isGranted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.orange)
                    }
                }
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(NoirColors.paperWhite.opacity(0.7))
                    .lineSpacing(3)
            }
            
            // Grant button
            if !isGranted {
                Button("Grant") {
                    viewModel.permissionsManager.openSystemPreferences(for: permissionType)
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(NoirColors.paperWhite)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(NoirColors.paperWhite.opacity(0.15))
                .clipShape(.rect(cornerRadius: 6))
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.03))
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isGranted ? Color.green.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .animation(AnimationCurves.spring.delay(delay), value: isVisible)
    }
    
    private func requestAllPermissions() {
        viewModel.permissionsManager.requestScreenRecording()
        viewModel.permissionsManager.requestAccessibility()
        
        // Open System Preferences
        viewModel.permissionsManager.openSystemPreferences(for: .screenRecording)
    }
}

#Preview {
    PermissionsScreen(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 700)
        .background(NoirColors.charcoalGray)
}
