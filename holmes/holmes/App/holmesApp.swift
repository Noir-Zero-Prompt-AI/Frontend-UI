import SwiftUI

@main
struct holmesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    @State private var launchAtLogin = false
    @State private var showNotchAnimation = true
    @State private var enableVoiceInput = true
    
    var body: some View {
        TabView {
            GeneralSettingsView(
                launchAtLogin: $launchAtLogin,
                showNotchAnimation: $showNotchAnimation
            )
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
            
            HotkeysSettingsView()
                .tabItem {
                    Label("Hotkeys", systemImage: "keyboard")
                }
            
            PrivacySettingsView()
                .tabItem {
                    Label("Privacy", systemImage: "lock.shield")
                }
            
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 450, height: 300)
    }
}

struct GeneralSettingsView: View {
    @Binding var launchAtLogin: Bool
    @Binding var showNotchAnimation: Bool
    
    var body: some View {
        Form {
            Toggle("Launch at Login", isOn: $launchAtLogin)
            
            if NotchDetector.hasNotch {
                Toggle("Show Notch Animation", isOn: $showNotchAnimation)
            }
            
            Divider()
            
            LabeledContent("Side Icon Position") {
                Button("Reset to Default") {
                    UserDefaults.standard.removeObject(forKey: "SideIconPosition")
                }
            }
        }
        .padding()
    }
}

struct HotkeysSettingsView: View {
    var body: some View {
        Form {
            LabeledContent("Open Search") {
                Text("Control + Space")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            LabeledContent("Open Assistant") {
                Text("Option + Space")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            LabeledContent("Toggle Side Icon") {
                Text("Command + \\")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Form {
            LabeledContent("Screen Recording") {
                HStack {
                    Image(systemName: PermissionManager.checkScreenRecordingPermission() ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(PermissionManager.checkScreenRecordingPermission() ? .green : .red)
                    
                    Button("Open Settings") {
                        PermissionManager.openScreenRecordingSettings()
                    }
                }
            }
            
            LabeledContent("Accessibility") {
                HStack {
                    Image(systemName: PermissionManager.checkAccessibilityPermission() ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(PermissionManager.checkAccessibilityPermission() ? .green : .red)
                    
                    Button("Open Settings") {
                        PermissionManager.openAccessibilitySettings()
                    }
                }
            }
            
            Divider()
            
            Text("Holmes processes all data locally on your device. No data is sent to external servers.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .thin))
                .foregroundColor(.primary)
                .rotationEffect(.degrees(-45))
            
            Text("Holmes")
                .font(.title)
            
            Text("Zero Prompt AI for macOS")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SettingsView()
}
