# Grain Setup Guide

## Quick Start with Xcode

### Step 1: Open Xcode

Launch **Xcode 15.0** or later.

### Step 2: Create New macOS App

1. **File** → **New** → **Project**
2. Select **macOS** tab → **App** template
3. Click **Next**

### Step 3: Project Configuration

Fill in the following:

- **Product Name**: `Grain`
- **Team**: Select your Apple Developer Team
- **Organization Identifier**: `com.yourname` (or your reverse domain)
- **Bundle Identifier**: Will auto-generate as `com.yourname.Grain`
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: None
- **Include Tests**: Unchecked (optional)

Click **Next** and save to: `/Users/rouler4wd/Desktop/Grain/`

**Important**: When Xcode asks about creating a Git repository, choose **Don't Create**.

### Step 4: Replace Default Files

Xcode will create default files. We need to replace them:

1. In Xcode's **Project Navigator** (left sidebar):
   - Select the default `GrainApp.swift` file → **Delete** → **Move to Trash**
   - Select the default `ContentView.swift` file → **Delete** → **Move to Trash**
   - Delete any other default Swift files

2. **Add Our Files**:
   - Right-click on the `Grain` folder (blue icon) in Project Navigator
   - Choose **Add Files to "Grain"...**
   - Navigate to `/Users/rouler4wd/Desktop/Grain/Grain/Grain/`
   - Select **ALL** folders: `App`, `Views`, `Components`, `Core`, `Design`
   - **IMPORTANT**: Uncheck "Copy items if needed" (we want to reference, not copy)
   - Check "Create groups"
   - Click **Add**

### Step 5: Configure Info.plist

1. In Project Navigator, select the **Grain** project (top blue icon)
2. Select the **Grain** target (under TARGETS)
3. Go to the **Info** tab
4. Click the **+** button to add these custom keys:

| Key | Type | Value |
|-----|------|-------|
| `NSScreenCaptureUsageDescription` | String | `Grain observes your screen to understand context and automate tasks.` |
| `NSAccessibilityUsageDescription` | String | `Required to interact with applications on your behalf.` |
| `NSAppleEventsUsageDescription` | String | `Enables automation of repetitive tasks across applications.` |

### Step 6: Configure Signing & Capabilities

1. Still in the **Grain** target settings
2. Go to **Signing & Capabilities** tab

3. **Disable App Sandbox** (required for global hotkeys):
   - If "App Sandbox" capability exists, hover over it and click the **−** button to remove it
   - If it doesn't exist, skip this step

4. **Add Required Capabilities**:
   - Click **+ Capability** button
   - Add **Hardened Runtime**
   - Under Hardened Runtime, enable:
     - ✓ Disable Library Validation (optional, for development)
     - ✓ Allow Apple Events (required)
     - ✓ Audio Input (for voice features)

### Step 7: Set Deployment Target

1. In the **General** tab of Grain target
2. Find **Minimum Deployments**
3. Set **macOS** to **13.0**

### Step 8: Add Assets (Optional)

1. In Project Navigator, find `Assets.xcassets`
2. Add these assets if you have them:
   - **App Icon**: Drag a 1024x1024 PNG to `AppIcon`
   - **Noir Icon**: Add an image set called `noir-icon` (detective silhouette)
   - **Grain Texture**: Add an image set called `grain-texture` (film grain PNG)

For now, the app will use SF Symbols as placeholders.

### Step 9: Build and Run

1. Select **My Mac** as the build destination (top toolbar)
2. Press **Cmd+R** or click the **Play** button to build and run
3. If you see build errors, check:
   - All files are properly added
   - Deployment target is macOS 13.0
   - SwiftUI is selected as interface

### Step 10: Grant Permissions

When the app launches:

1. **Onboarding will appear** (4 screens)
2. On the **Permissions** screen:
   - Click **Grant Permissions**
   - System Settings will open
   - Navigate to **Privacy & Security**
   - Add Grain to:
     - Screen Recording
     - Accessibility
     - Automation
3. Return to the app and click **Check Status**
4. Complete onboarding

---

## Manual Permission Setup

If permissions don't work automatically:

### Screen Recording Permission

1. Open **System Settings**
2. Go to **Privacy & Security** → **Screen Recording**
3. Click the **+** button
4. Navigate to your Grain app (in Xcode's derived data or Applications folder)
5. Select `Grain.app` and click **Open**
6. Toggle the switch to **ON**

### Accessibility Permission

1. **System Settings** → **Privacy & Security** → **Accessibility**
2. Click the **+** button
3. Add `Grain.app`
4. Toggle **ON**

### Restart Required

After granting permissions, **quit and relaunch** Grain.

---

## Troubleshooting

### Build Error: "Cannot find 'OnboardingFlow' in scope"

**Solution**: Make sure all files in `Views/Onboarding/` are added to the target:
1. Select each Swift file in Project Navigator
2. In **File Inspector** (right sidebar), check the **Target Membership**
3. Ensure **Grain** is checked

### Build Error: "Cannot find type 'NoirColors' in scope"

**Solution**: Add the `Design` folder files to the target (same as above).

### App Crashes on Launch

**Possible causes**:
- Missing entitlements (App Sandbox should be disabled)
- Deployment target mismatch
- Check Xcode console for error messages

### Search Bar Not Responding to Control+Space

**Conflict with Spotlight**:
1. **System Settings** → **Keyboard** → **Keyboard Shortcuts**
2. Select **Spotlight**
3. Disable "Show Spotlight search" (Control+Space)
4. Or change Grain's hotkey in `HotkeyManager.swift`

### Side Icon Not Appearing

**Check**:
1. Onboarding was completed (UserDefaults key `hasCompletedOnboarding`)
2. Look at the center-right edge of the screen
3. Try pressing **Option+Space** to toggle it

---

## Development Tips

### Preview Files

Most View files include `#Preview` macros. To see previews:
1. Open a view file (e.g., `SearchBarView.swift`)
2. Press **Opt+Cmd+Return** to show Canvas
3. Click **Resume** in the canvas to see the preview

### Debug Hotkeys

Add print statements in `HotkeyManager.swift` to debug:

```swift
func setupSearchBarHotkey() {
    print("🔧 Search bar hotkey registered")
    // ... rest of code
}
```

### Test Notch Detection

Run this in a playground or view:

```swift
if NotchDetector.hasNotch() {
    print("✓ Notch detected!")
} else {
    print("✗ No notch (will use fallback)")
}
```

### Reset Onboarding

To see onboarding again during testing:

```bash
defaults delete com.yourname.Grain hasCompletedOnboarding
```

### Clear Side Icon Position

```bash
defaults delete com.yourname.Grain sideIconX
defaults delete com.yourname.Grain sideIconY
```

---

## Next Steps

After successful setup:

1. **Test all hotkeys** (Control+Space, Option+Space)
2. **Drag the side icon** to different positions
3. **Check notch animation** (if you have a MacBook Pro with notch)
4. **Customize colors** in `NoirColors.swift`
5. **Add app icon** to Assets.xcassets
6. **Implement voice recognition** (see `SearchBarView.swift`)

---

## File Checklist

After setup, verify these files are in Xcode:

### App
- [x] `GrainApp.swift`
- [x] `AppDelegate.swift`
- [x] `Permissions.swift`

### Design
- [x] `NoirColors.swift`
- [x] `NoirFonts.swift`
- [x] `AnimationCurves.swift`

### Components
- [x] `GlassCard.swift`
- [x] `GrainOverlay.swift`
- [x] `NoirButton.swift`
- [x] `NoirTextField.swift`

### Core
- [x] `HotkeyManager.swift`
- [x] `ScreenObserver.swift`
- [x] `AgentBrain.swift`

### Views/Onboarding
- [x] `OnboardingFlow.swift`
- [x] `OnboardingViewModel.swift`
- [x] `WelcomeScreen.swift`
- [x] `HowItWorksScreen.swift`
- [x] `PermissionsScreen.swift`
- [x] `ReadyScreen.swift`

### Views/SearchBar
- [x] `SearchBarWindow.swift`
- [x] `SearchBarView.swift`

### Views/SideIcon
- [x] `SideIconWindow.swift`
- [x] `SideIconView.swift`

### Views/NotchAnimation
- [x] `NotchDetector.swift`
- [x] `NotchView.swift`

### Views/MainPanel
- [x] `MainPanelView.swift`

---

**Ready to build!** Follow the steps above and you'll have a working Grain prototype.
