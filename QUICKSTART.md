# Grain - Quick Start Guide

## ⚡ 3-Minute Setup

### Step 1: Open Xcode
```bash
# Launch Xcode 15.0+
open /Applications/Xcode.app
```

### Step 2: Create Project
1. **File** → **New** → **Project**
2. Select **macOS** → **App**
3. Name: `Grain`
4. Interface: **SwiftUI**
5. Save to: `/Users/rouler4wd/Desktop/Grain/`

### Step 3: Add Files
1. Delete default `GrainApp.swift` and `ContentView.swift`
2. Right-click `Grain` folder → **Add Files to "Grain"...**
3. Select folders: `App`, `Views`, `Components`, `Core`, `Design`
4. **Uncheck** "Copy items if needed"
5. Click **Add**

### Step 4: Configure
1. Select **Grain** target → **Info** tab
2. Add permission keys:
   - `NSScreenCaptureUsageDescription`
   - `NSAccessibilityUsageDescription`
   - `NSAppleEventsUsageDescription`
3. Go to **Signing & Capabilities**
4. Remove **App Sandbox** if present
5. Set **Deployment Target** to **macOS 13.0**

### Step 5: Build
```
Press ⌘R (Cmd+R) to build and run
```

---

## 🎹 Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Control + Space` | Open search bar |
| `Option + Space` | Toggle main panel |
| `Command + \` | Show/hide side icon |
| `ESC` | Dismiss windows |
| `Cmd + Return` | Submit search |

---

## 🎨 UI Components

### Search Bar (Control+Space)
- **Location**: Top-center of screen
- **Size**: 800×150px
- **Features**: Large text input, voice mode, glass blur

### Side Icon (Option+Space)
- **Location**: Draggable (default: center-right)
- **States**: Dormant → Listening → Thinking → Acting
- **Persistent**: Position saved automatically

### Main Panel
- **Size**: 400×600px
- **Content**: Context cards, suggestions, activity log
- **Position**: Right side of screen

### Notch Animation
- **Availability**: MacBook Pro 14"/16" only
- **Behavior**: Idle breathing → Active task display
- **Fallback**: Hidden on non-notch Macs

---

## 📁 File Structure

```
Grain/Grain/
├── App/                    # Core app files
├── Views/
│   ├── Onboarding/         # 4-screen onboarding
│   ├── SearchBar/          # Control+Space UI
│   ├── SideIcon/           # Draggable icon
│   ├── NotchAnimation/     # Notch integration
│   └── MainPanel/          # Main glass panel
├── Components/             # Reusable UI
├── Core/                   # Hotkeys, permissions
└── Design/                 # Colors, fonts, animations
```

---

## 🔧 Common Issues

### Build Error: "Cannot find 'X' in scope"
**Fix**: Check target membership in File Inspector

### Search bar not responding to Control+Space
**Fix**: Disable Spotlight shortcut in System Settings

### Permissions not working
**Fix**: Manually add Grain to System Settings → Privacy & Security

### Side icon not visible
**Fix**: Complete onboarding or check center-right edge

---

## 🎯 What Works

✅ Heavy glass morphism UI  
✅ Film grain overlay  
✅ 4-screen onboarding  
✅ Global hotkeys  
✅ Draggable side icon  
✅ Notch detection  
✅ Permission handling  

## 🚧 What's Stubbed

🔨 Voice recognition  
🔨 Screen capture  
🔨 AI suggestions  
🔨 Task execution  

---

## 📚 Full Documentation

- **SETUP.md** - Detailed setup instructions
- **README.md** - Project overview
- **PROJECT_SUMMARY.md** - Complete feature list
- **AGENTS.md** - Original specification

---

## ✅ Verification

Run this to check all files:
```bash
./verify_setup.sh
```

Expected output:
```
✅ All files present!
Total files checked: 28
Found: 28
Missing: 0
```

---

## 🎉 You're Ready!

Press **⌘R** in Xcode to launch Grain.

Complete the onboarding, grant permissions, and start exploring!

---

**Questions?** Check SETUP.md for troubleshooting.
