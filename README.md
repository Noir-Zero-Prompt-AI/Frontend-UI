# Grain - Zero Prompt AI Desktop Agent

**A macOS 13.0+ desktop AI agent with detective noir aesthetic and heavy glass morphism design.**
**NEED CLERK INTEGRATION/ FIX UI**
**Lottie DOES NOT show up, goes back to fallback(purple G) needs fixing**

<img width="396" height="597" alt="Screenshot 2026-02-02 at 12 04 10 PM" src="https://github.com/user-attachments/assets/4c96554e-9f3f-414f-b2dc-e14a8f0f14b6" />
<img width="840" height="252" alt="Screenshot 2026-02-02 at 12 04 07 PM" src="https://github.com/user-attachments/assets/8b0ade86-fae6-4816-b8d8-8efc3c3a0645" />
<img width="109" height="116" alt="Screenshot 2026-02-02 at 12 04 21 PM" src="https://github.com/user-attachments/assets/f2344965-32e4-42b4-ab36-7f4d9ecb9a3a" />



## Features

- 🔍 **Search Bar** (Control+Space) - Glass-style floating search with voice input
- 🤖 **Side Icon** (Option+Space) - Draggable detective character assistant
- 📱 **Notch Animation** - MacBook Pro notch integration (auto-detects)
- 🎨 **Main Panel** - Glass morphism control center with context awareness
- 🎬 **Film Noir Aesthetic** - Monochromatic design with film grain overlay
- ⚡ **Zero Prompt AI** - Learns from your actions (frontend phase)

## Project Structure

```
Grain/
├── Grain/
│   ├── App/
│   │   ├── GrainApp.swift              # @main entry point
│   │   ├── AppDelegate.swift           # Window management
│   │   └── Permissions.swift           # Permission handling
│   ├── Views/
│   │   ├── Onboarding/                 # 4-screen onboarding flow
│   │   ├── SearchBar/                  # Control+Space UI
│   │   ├── SideIcon/                   # Option+Space icon
│   │   ├── NotchAnimation/             # Notch integration
│   │   └── MainPanel/                  # Main glass panel
│   ├── Components/
│   │   ├── GlassCard.swift             # Reusable glass container
│   │   ├── GrainOverlay.swift          # Film grain effect
│   │   ├── NoirButton.swift            # Themed button
│   │   └── NoirTextField.swift         # Themed input
│   ├── Core/
│   │   ├── HotkeyManager.swift         # Global hotkeys
│   │   ├── ScreenObserver.swift        # Screen monitoring (stub)
│   │   └── AgentBrain.swift            # AI logic (stub)
│   ├── Design/
│   │   ├── NoirColors.swift            # Color system
│   │   ├── NoirFonts.swift             # Typography
│   │   └── AnimationCurves.swift       # Custom easing
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── Grain.entitlements
├── Package.swift                       # Swift Package Manager
└── README.md
```

## Setup Instructions

### Option 1: Create Xcode Project (Recommended)

1. **Open Xcode** (version 15.0 or later)

2. **Create New Project**:
   - Choose **macOS → App**
   - Product Name: `Grain`
   - Team: Your Apple Developer Team
   - Organization Identifier: `com.yourname`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Include Tests: Optional
   - Save to: `/Users/rouler4wd/Desktop/Grain/`

3. **Replace Default Files**:
   - Delete the default `GrainApp.swift` and `ContentView.swift`
   - In Xcode, right-click on the `Grain` folder → **Add Files to "Grain"**
   - Select all folders from `/Users/rouler4wd/Desktop/Grain/Grain/Grain/`
   - Make sure **"Copy items if needed"** is unchecked
   - Click **Add**

4. **Configure Info.plist**:
   - In Xcode, select the `Grain` target
   - Go to **Info** tab
   - Add custom keys from `Grain/Info.plist` (permissions descriptions)

5. **Configure Entitlements**:
   - Go to **Signing & Capabilities** tab
   - Click **+ Capability** → Add **App Sandbox** (disable it)
   - Add **Apple Events** and **Audio Input**
   - Or replace with the provided `Grain.entitlements` file

6. **Set Deployment Target**:
   - In **General** tab, set **macOS Deployment Target** to **13.0**

7. **Build and Run**:
   - Press **Cmd+R** to build and run
   - Grant permissions when prompted

### Option 2: Swift Package Manager

```bash
cd /Users/rouler4wd/Desktop/Grain
swift build
swift run Grain
```

**Note**: SPM builds console apps by default. For full macOS app with UI, use Xcode.

## Usage

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| **Control + Space** | Open search bar (Glass-style) |
| **Option + Space** | Toggle side panel + icon |
| **Command + \\** | Show/hide side icon |
| **ESC** | Dismiss active UI |
| **Cmd + Return** | Submit search query |

### First Launch

1. **Onboarding Flow** (4 screens):
   - Welcome screen
   - How it works
   - Permissions request
   - Ready to go

2. **Grant Permissions**:
   - **Screen Recording**: System Settings → Privacy & Security → Screen Recording
   - **Accessibility**: System Settings → Privacy & Security → Accessibility
   - **Automation**: System Settings → Privacy & Security → Automation

3. **Start Using**:
   - Side icon appears at center-right edge (draggable)
   - Press **Control+Space** for search bar
   - Press **Option+Space** for main panel

## Design System

### Colors (Noir Theme)

```swift
NoirColors.shadowBlack    // #0A0A0A - Deep shadows
NoirColors.charcoalGray   // #1C1C1C - Primary bg
NoirColors.smokeGray      // #3A3A3A - Secondary
NoirColors.fogGray        // #6B6B6B - Tertiary
NoirColors.paperWhite     // #E8E8E8 - Text
NoirColors.glassWhite     // rgba(255,255,255,0.1)
```

### Glass Morphism

```swift
GlassCard {
    // Your content
}
```

Uses `.ultraThickMaterial` + dark gradient overlay for heavy glass effect.

### Film Grain

```swift
FilmGrainOverlay(opacity: 0.08)
```

Adds subtle noise texture for detective noir aesthetic.

## Development Status

### ✅ Completed (Frontend Phase)

- [x] Design system (colors, fonts, animations)
- [x] Glass morphism components
- [x] Onboarding flow (4 screens)
- [x] Search Bar UI (Control+Space)
- [x] Side Icon system (draggable, persistent position)
- [x] Notch Animation (with hardware detection)
- [x] Main Panel UI
- [x] Permissions handling
- [x] Global hotkeys (basic implementation)

### 🚧 In Progress

- [ ] Xcode project configuration
- [ ] Testing on physical Mac hardware
- [ ] App icon and assets
- [ ] Film grain texture image

### 📋 Future (Backend Integration)

- [ ] Screen capture implementation (ScreenCaptureKit)
- [ ] OCR text extraction (Vision framework)
- [ ] AI model integration (LLM)
- [ ] Task execution engine
- [ ] Behavior learning system
- [ ] Voice recognition (AVFoundation)

## Dependencies

### Required Frameworks

- **SwiftUI** - UI framework
- **AppKit** - Window management
- **Combine** - Reactive state
- **Carbon** - Global hotkeys

### Optional (Future)

- **ScreenCaptureKit** - Screen monitoring
- **Vision** - OCR
- **CoreML** - AI inference
- **AVFoundation** - Voice input

## Performance Targets

| Metric | Target | Notes |
|--------|--------|-------|
| App Launch | <1.5s | To background ready |
| Memory (Idle) | <150 MB | Activity Monitor |
| Memory (Active) | <300 MB | During screen capture |
| CPU (Idle) | <2% | Background monitoring |
| Animation FPS | 60fps | Instruments profiling |
| Hotkey Response | <50ms | Control+Space to visible |

## Troubleshooting

### Search Bar Not Appearing

- Check hotkey conflicts (System Settings → Keyboard → Keyboard Shortcuts)
- Try restarting the app
- Ensure app has focus

### Permissions Not Working

- Go to System Settings → Privacy & Security
- Manually add Grain to Screen Recording and Accessibility
- Restart the app after granting permissions

### Side Icon Not Draggable

- The icon window should be movable by dragging
- Position is saved to UserDefaults
- Reset: `defaults delete com.yourname.Grain sideIconX sideIconY`

### Notch Animation Not Showing

- Only works on MacBook Pro 14"/16" with notch
- Gracefully falls back on non-notch Macs
- Check `NotchDetector.hasNotch()` returns true

## Architecture

### State Management

- Uses `@Observable` macro (Swift 5.9+)
- `@MainActor` for UI thread safety
- Combine for notifications

### Window Management

- `SearchBarWindow` - Floating, borderless, top-center
- `SideIconWindow` - Floating, draggable, persistent
- `MainPanelWindow` - Floating, dismissible

### Hotkey System

- Carbon Events API for global hotkeys
- Notification-based event distribution
- ESC key monitoring for dismissal

## Contributing

This is a frontend prototype based on the AGENTS.md specification. Backend AI functionality is planned for future phases.

## License

Copyright © 2026. All rights reserved.

## Credits

- **Design Reference**: [Glass](https://github.com/pickle-com/glass) - Search bar inspiration
- **Aesthetic**: Detective noir films, grainy cinematography
- **Framework**: SwiftUI + AppKit

---

**Built with SwiftUI for macOS 13.0+**

For questions or issues, refer to the AGENTS.md specification document.
