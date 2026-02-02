# Zero Prompt AI - Desktop Agent Specification

**Project Name**: Grain  
**Platform**: macOS 13.0+ (Ventura+)  
**Framework**: Swift + SwiftUI  
**Status**: Frontend Development Phase  
**Backend Integration**: Post-frontend completion

---

## Vision Statement

An autonomous desktop AI agent that learns from user actions and proactively completes tasks without explicit prompting. The agent observes screen activity, understands context, and executes workflows independently—approaching desktop AGI.

**Design Philosophy**: Grainy detective noir aesthetic meets Apple's glass morphism. Professional, shadowy, low-key with black/white/gray palette.

---

## Core Components

### 1. Search Bar (Control + Space)
**Trigger**: Control + Space (global hotkey)  
**Location**: Top-center of screen (floating, ~100-150px from top edge)  
**Design Reference**: https://github.com/pickle-com/glass  
**Behavior**:
- Heavy glass blur effect (deep frosted glass, not subtle)
- Large, prominent text input area
- Appears with smooth fade-in + scale animation (0.95 → 1.0)
- Auto-dismisses when focus lost or ESC pressed
- Natural language input for AI commands

**Visual Characteristics**:
- **Shape**: Rounded rectangle with pronounced corner radius (~24-32px)
- **Size**: ~700-800px wide × ~120-150px tall (large and prominent)
- **Glass Effect**: Thick blur (Material.ultraThickMaterial or custom heavy blur)
- **Background**: Dark tinted glass with subtle gradient
- **Border**: Subtle light border (1-2px, rgba(255,255,255,0.2))
- **Shadow**: Large soft shadow for depth (0 20px 60px rgba(0,0,0,0.4))
- **Text Input**: Large centered text, minimal placeholder like "Glass" or just cursor

**UI Layout** (from reference screenshot):
```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  ┌──────────────────────────────────────────────────────┐    │
│  │  Listen |||    Ask ⌘↵    Show/Hide ⌘ \         ⋮    │    │ ← Controls bar (top)
│  └──────────────────────────────────────────────────────┘    │
│                                                                │
│                          Glass                                 │ ← Large centered input
│                            |                                   │ ← Cursor
│                                                                │
└────────────────────────────────────────────────────────────────┘
     ↑ Heavy glass blur with dark tint
```

**Button Layout** (top control bar):
- **Listen |||**: Voice input mode (left side, pill-shaped button)
- **Ask ⌘↵**: Submit query (center-left)
- **Show/Hide ⌘ \\**: Toggle side icon (center-right)
- **⋮ (Menu)**: Settings dropdown (right side)

**Typography**:
- Input text: SF Pro Display, size 48-56pt, weight Regular or Light
- Buttons: SF Pro Text, size 14-16pt, weight Medium
- Color: White/light gray (rgba(255,255,255,0.9))

**Animation**:
```swift
// Appearance animation
.scaleEffect(isVisible ? 1.0 : 0.95)
.opacity(isVisible ? 1.0 : 0)
.animation(.spring(response: 0.3, dampingFraction: 0.8), value: isVisible)
```

### 2. Notch Animation System (MacBook Pro 14"/16" only)
**Availability**: Only on Macs with physical notch  
**Fallback**: No animation on notch-less Macs (clean approach)  
**Behavior**:
- Ambient idle state (subtle breathing/scanning animation)
- Expands on AI activity detection
- Shows visual feedback during task execution
- Minimizes when task complete
- Click opens main panel (Option + Space equivalent)

**Implementation Note**: Detect notch presence via screen bounds, gracefully skip animation on unsupported hardware.

### 3. Side Panel Icon (Clippy-style Assistant)
**Trigger**: Option + Space (global hotkey) OR click notch  
**Default Location**: Right edge, center-vertical  
**Draggable**: Yes - user can reposition anywhere on screen, position persists  
**States**:
- **Dormant**: Small icon, low opacity, grainy texture
- **Listening**: Pulsing animation, increased opacity
- **Thinking**: Subtle processing animation
- **Acting**: Task execution visual feedback

**Character Design** (based on noir.svg):
- Detective/noir character silhouette
- Minimal animations (professional, not cartoonish)
- Shadows and lighting effects that match noir aesthetic
- Glass morphism overlay when active

### 4. Main Application Window
**Trigger**: Option + Space (shows side icon + panel) OR notch click  
**Presentation**: Floating overlay panel  
**Dimensions**: ~400x600px, resizable  
**Position**: Anchored near side icon or notch

**UI Elements**:
```
┌─────────────────────────────────┐
│  [Icon]         Grain           │ ← Header (glass blur)
├─────────────────────────────────┤
│                                 │
│  "I noticed you're working on   │
│   the Q4 presentation..."       │ ← Context awareness
│                                 │
│  Suggested Actions:             │
│  ○ Format charts consistently   │
│  ○ Update revenue projections   │ ← Autonomous suggestions
│  ○ Check spelling & grammar     │
│                                 │
├─────────────────────────────────┤
│  Recent Activity ▼              │ ← Collapsible sections
│  • Renamed 3 files (2m ago)     │
│  • Updated Excel formulas       │
│  • Organized downloads folder   │
│                                 │
└─────────────────────────────────┘
```

---

## Hotkey Mapping

| Hotkey | Action | Component |
|--------|--------|-----------|
| **Control + Space** | Open search bar | Top-center search UI |
| **Option + Space** | Toggle side icon + panel | Side icon & main panel |
| **Command + Return** | Submit search query | Search bar (when focused) |
| **Command + \\** | Show/Hide side icon | Side icon visibility |
| **ESC** | Dismiss active UI | All components |

---

## Technical Architecture

### Swift Frameworks Required

```swift
import SwiftUI
import AppKit
import ScreenCaptureKit      // Screen monitoring
import Accessibility          // UI element detection
import Vision                 // OCR + object detection
import CoreML                 // On-device AI inference
import Combine                // Reactive state management
import HotKey                 // Global keyboard shortcuts
```

### Key Classes

**3. SearchBarController**
- Control + Space hotkey handler
- Floating window management (always-on-top, centered)
- Heavy glass blur implementation (reference: https://github.com/pickle-com/glass)
- Text input handling with large font rendering
- Voice input integration (AVFoundation)
- Auto-dismiss on focus loss
- Scale + fade animation on appear/disappear

**2. NotchAnimationController** (notch Macs only)
- Detects notch presence via NSScreen.safeAreaInsets
- Manages Dynamic Island-style animations in notch area
- Coordinates with system UI to avoid conflicts
- Handles expansion/collapse states
- Gracefully disabled on non-notch hardware

**3. SideIconManager**
- Persistent window overlay (always-on-top)
- Drag-to-reposition functionality
- State-based animation controller

**3. ScreenObserver**
- Continuous screen capture (privacy-respecting)
- OCR text extraction
- UI element hierarchy detection
- Activity pattern learning

**4. AgentBrain** (placeholder for backend integration)
- Context understanding
- Task suggestion engine
- Autonomous action execution
- User behavior learning model

**5. GlassUIComponents**
- Reusable noir-themed SwiftUI components
- Grainy texture overlays
- Glass morphism blur effects
- Monochromatic color system

---

## Design System

### Color Palette

```swift
// Noir Detective Theme
struct NoirColors {
    static let shadowBlack = Color(hex: "#0A0A0A")      // Deep shadows
    static let charcoalGray = Color(hex: "#1C1C1C")     // Primary bg
    static let smokeGray = Color(hex: "#3A3A3A")        // Secondary elements
    static let fogGray = Color(hex: "#6B6B6B")          // Tertiary/disabled
    static let paperWhite = Color(hex: "#E8E8E8")       // Text/highlights
    static let glassWhite = Color(hex: "#FFFFFF").opacity(0.1) // Glass overlay
}
```

### Typography

```swift
// Professional, readable, detective-noir vibe
Font.system(.body, design: .monospaced)      // Code/technical text
Font.system(.headline, design: .rounded)     // Headers
Font.custom("SF Pro Display", size: 16)      // Body text
```

### Material Effects

```swift
// Heavy Glass Morphism (Glass reference style)
.background(.ultraThickMaterial)             // System thick glass
.background(
    LinearGradient(
        colors: [
            Color.black.opacity(0.3),
            Color.black.opacity(0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
)                                             // Dark tint overlay
.overlay(
    RoundedRectangle(cornerRadius: 24)
        .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
)                                             // Subtle border

// Alternative: Custom blur effect (if system materials aren't heavy enough)
.background(
    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        .overlay(Color.black.opacity(0.4))   // Additional darkening
)

// Film Grain Overlay (subtle, don't overpower glass effect)
Image("grain-texture")
    .resizable()
    .blendMode(.overlay)
    .opacity(0.08)                            // Very subtle
```

### Animation Principles

- **Duration**: 0.3-0.5s (professional pace)
- **Easing**: `.easeInOut` or custom bezier (no bouncy)
- **Subtle**: Prefer opacity/blur changes over scale
- **Purposeful**: Every animation conveys system state

---

## User Interaction Flow

### First Launch Experience

1. **Permission Requests** (presented sequentially with noir-themed UI):
   - Screen Recording
   - Accessibility
   - Automation
   - (Each with clear explanation of why needed)

2. **Onboarding** (3 screens, skippable):
   - Screen 1: "I observe. You work." (shows notch animation)
   - Screen 2: "Option + Space anytime" (shows side icon + hotkey)
   - Screen 3: "Learning starts now" (privacy explanation)

3. **Calibration Phase** (1-2 hours):
   - Passive observation mode
   - No autonomous actions yet
   - Builds baseline user behavior model
   - Shows occasional "I'm learning..." status in notch

### Daily Usage Pattern

```
User boots Mac
    ↓
Notch shows subtle scanning animation (if notch Mac) | Side icon appears right edge
    ↓
User works normally
    ↓
User presses Control+Space → Search bar appears at top
    ↓
User types: "rename all my screenshots from today"
    ↓
Search bar processes → Shows confirmation: "Rename 12 screenshots?"
    ↓
User presses Enter → Task executes → Search bar dismisses
    ↓
Notch (if present) shows brief "Task complete" animation
```

**Alternative Flow (Zero Prompt - Autonomous)**:
```
Agent detects pattern (e.g., user always renames screenshots after taking them)
    ↓
Notch pulses briefly OR side icon animates → "I can do this for you"
    ↓
User clicks notch/side icon OR presses Option+Space
    ↓
Panel shows: "Auto-rename screenshots from now on?"
    ↓
User approves → Agent executes autonomously going forward
```

### Control + Space Behavior (Search Bar)

**Quick Tap**:
- Opens search bar (top-center)
- Cursor auto-focuses in text field
- Shows placeholder: "Ask Grain anything..."

**Typing + Enter**:
- Processes natural language command
- Shows brief loading state
- Executes task OR asks for clarification
- Auto-dismisses after task completion

**Voice Mode (Click "Listen")**:
- Changes to listening state (red indicator)
- Shows audio waveform animation
- Transcribes speech to text
- Auto-submits when user stops speaking (2s silence)

### Option + Space Behavior

**Quick Tap** (< 0.5s):
- Opens side icon if dormant
- Shows main panel if side icon already visible

**Hold** (> 0.5s):
- Opens main panel in "manual mode"
- User can type natural language command
- Falls back to traditional AI assistant behavior

---

## Notch Animation Specifications

### Idle State
```swift
// Subtle breathing animation
Rectangle()
    .fill(LinearGradient(
        colors: [.clear, NoirColors.glassWhite, .clear],
        startPoint: .leading,
        endPoint: .trailing
    ))
    .frame(width: 200, height: 30)
    .mask(RoundedRectangle(cornerRadius: 20))
    .animation(.easeInOut(duration: 3).repeatForever(), value: breathingPhase)
```

**Visual**: Horizontal grainy bar that slowly pulses (scanning effect)

### Active State (Task Execution)
```swift
// Expands from notch downward
VStack {
    HStack {
        Image(systemName: "brain.head.profile")
            .symbolEffect(.pulse)
        Text("Organizing files...")
            .font(.system(.caption, design: .monospaced))
    }
    ProgressView(value: progress)
        .tint(NoirColors.paperWhite)
}
.padding()
.background(.ultraThinMaterial)
.mask(RoundedRectangle(cornerRadius: 12))
.frame(maxWidth: 300)
.transition(.move(edge: .top).combined(with: .opacity))
```

**Behavior**:
- Expands smoothly from notch (200ms animation)
- Shows task name + progress
- Collapses back after completion (500ms delay)
- Never blocks screen content (semi-transparent)

### Interaction States
- **Hover**: Slight brightness increase
- **Click**: Opens main panel anchored to notch
- **Right-click**: Quick settings menu (pause agent, preferences)

---

## Side Icon Specifications

### Icon Asset (from noir.svg)
```swift
// Convert SVG to SF Symbol or PNG sequences
// Maintain noir detective silhouette
// Add subtle animation frames:
// - Frame 1: Standing (idle)
// - Frame 2: Head tilt (listening)
// - Frame 3: Lean forward (thinking)
// - Frame 4: Hand gesture (acting)
```

### Window Properties
```swift
// Always-on-top, frameless window
class SideIconWindow: NSWindow {
    override init(contentRect: NSRect, 
                  styleMask: NSWindow.StyleMask, 
                  backing: NSWindow.BackingStoreType, 
                  defer: Bool) {
        super.init(contentRect: contentRect, 
                   styleMask: [.borderless], 
                   backing: backing, 
                   defer: `defer`)
        
        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.isMovableByWindowBackground = true
    }
}
```

### Positioning System
```swift
enum SideIconPosition: Codable {
    case centerRight                        // DEFAULT
    case topRight(offset: CGFloat)
    case bottomRight(offset: CGFloat)
    case centerLeft
    case topLeft(offset: CGFloat)
    case bottomLeft(offset: CGFloat)
    case custom(x: CGFloat, y: CGFloat)
}

// User can drag to reposition anywhere, snaps to edges
// Default: centerRight (vertically centered on right edge)
// Saves position to UserDefaults
```

---

## File Structure

```
Grain/
├── Grain.xcodeproj
├── Grain/
│   ├── App/
│   │   ├── GrainApp.swift                  # App entry point
│   │   ├── AppDelegate.swift               # Window management
│   │   └── Permissions.swift               # Permission handling
│   │
│   ├── Views/
│   │   ├── Onboarding/
│   │   │   ├── OnboardingFlow.swift        # Main onboarding coordinator
│   │   │   ├── WelcomeScreen.swift         # Screen 1: Welcome
│   │   │   ├── HowItWorksScreen.swift      # Screen 2: How it works
│   │   │   ├── PermissionsScreen.swift     # Screen 3: Permissions
│   │   │   ├── ReadyScreen.swift           # Screen 4: Ready to go
│   │   │   └── OnboardingViewModel.swift   # State management
│   │   │
│   │   ├── SearchBar/
│   │   │   ├── SearchBarView.swift         # Main search UI (Control+Space)
│   │   │   ├── SearchBarWindow.swift       # Floating window controller
│   │   │   ├── VoiceInputView.swift        # "Listen" button UI
│   │   │   └── SearchViewModel.swift       # Search state management
│   │   │
│   │   ├── NotchAnimation/
│   │   │   ├── NotchView.swift             # Main notch UI
│   │   │   ├── NotchDetector.swift         # Hardware detection
│   │   │   ├── IdleState.swift             # Breathing animation
│   │   │   ├── ActiveState.swift           # Task execution UI
│   │   │   └── NotchViewModel.swift        # State management
│   │   │
│   │   ├── SideIcon/
│   │   │   ├── SideIconView.swift      # Icon UI
│   │   │   ├── IconAnimations.swift    # State transitions
│   │   │   └── SideIconWindow.swift    # Window controller
│   │   │
│   │   ├── MainPanel/
│   │   │   ├── MainPanelView.swift     # Primary UI
│   │   │   ├── ContextCard.swift       # AI awareness display
│   │   │   ├── ActionSuggestions.swift # Task list
│   │   │   └── ActivityLog.swift       # Recent actions
│   │   │
│   │   └── Onboarding/
│   │       ├── WelcomeFlow.swift       # First-run experience
│   │       └── PermissionViews.swift   # Permission requests
│   │
│   ├── Components/
│   │   ├── GlassCard.swift             # Reusable glass container
│   │   ├── GrainOverlay.swift          # Film grain effect
│   │   ├── NoirButton.swift            # Themed button
│   │   └── NoirTextField.swift         # Themed input
│   │
│   ├── Core/
│   │   ├── ScreenObserver.swift        # Screen monitoring
│   │   ├── AccessibilityMonitor.swift  # UI tree access
│   │   ├── HotkeyManager.swift         # Option+Space handler
│   │   └── AgentBrain.swift            # AI logic (stub for now)
│   │
│   ├── Design/
│   │   ├── NoirColors.swift            # Color system
│   │   ├── NoirFonts.swift             # Typography
│   │   └── AnimationCurves.swift       # Custom easing
│   │
│   ├── Assets.xcassets/
│   │   ├── noir-icon.svg               # Detective character
│   │   ├── grain-texture.png           # Film grain overlay
│   │   ├── app-icon.png                # macOS app icon
│   │   └── Colors/                     # Color assets
│   │
│   └── Resources/
│       ├── Info.plist
│       └── Entitlements.entitlements   # Required permissions
│
└── README.md
```

---

## Onboarding Experience

### First Launch Flow

Grain requires a thoughtful onboarding to request permissions and explain the zero-prompt AI concept. The onboarding should match the noir/glass aesthetic and feel professional.

**Structure**: 4 screens (welcome → explain → permissions → complete)

---

#### Screen 1: Welcome
**Visual**: 
- Large Grain icon (detective silhouette from noir.svg)
- Heavy glass background with grain texture
- Centered layout

```
╔═══════════════════════════════════════════╗
║                                           ║
║                                           ║
║              🎬                           ║ ← Large noir icon
║                                           ║
║             Grain                         ║ ← App name (large)
║                                           ║
║     Zero Prompt AI for macOS              ║ ← Tagline
║                                           ║
║   I learn from your actions and help     ║
║        before you even ask.               ║ ← Value prop
║                                           ║
║                                           ║
║          [Get Started]                    ║ ← Glass button
║                                           ║
╚═══════════════════════════════════════════╝
```

**Copy**:
- Headline: "Grain"
- Subhead: "Zero Prompt AI for macOS"
- Body: "I learn from your actions and help before you even ask."
- CTA: "Get Started"

---

#### Screen 2: How It Works
**Visual**:
- 3 panels showing Control+Space, Option+Space, and autonomous action
- Animated demonstrations (can be static mockups for now)

```
╔═══════════════════════════════════════════╗
║                                           ║
║          How Grain Works                  ║ ← Header
║                                           ║
║  ┌───────┐  ┌───────┐  ┌───────┐       ║
║  │ ⌃⎵    │  │ ⌥⎵    │  │  ⚡   │       ║ ← Icons
║  └───────┘  └───────┘  └───────┘       ║
║                                           ║
║   Search     Assistant   Automatic       ║ ← Labels
║                                           ║
║  Control+   Option+     I learn your     ║
║   Space      Space      patterns and     ║
║  for quick  for full    work without     ║
║  commands   panel       being asked      ║ ← Descriptions
║                                           ║
║                                           ║
║              [Continue]                   ║
║                                           ║
╚═══════════════════════════════════════════╝
```

**Copy**:
- Headline: "How Grain Works"
- Panel 1: "Control+Space for quick commands"
- Panel 2: "Option+Space for full assistant panel"
- Panel 3: "I learn your patterns and work without being asked"

---

#### Screen 3: Permissions Required
**Visual**:
- List of permissions with explanations
- Glass cards for each permission
- Clear reasoning for each

```
╔═══════════════════════════════════════════╗
║                                           ║
║        Permissions Needed                 ║ ← Header
║                                           ║
║  ┌─────────────────────────────────────┐ ║
║  │  🖥️  Screen Recording               │ ║ ← Card 1
║  │  To understand what you're working  │ ║
║  │  on and provide contextual help     │ ║
║  └─────────────────────────────────────┘ ║
║                                           ║
║  ┌─────────────────────────────────────┐ ║
║  │  ♿️  Accessibility                  │ ║ ← Card 2
║  │  To interact with apps on your      │ ║
║  │  behalf (clicking, typing, etc)     │ ║
║  └─────────────────────────────────────┘ ║
║                                           ║
║  ┌─────────────────────────────────────┐ ║
║  │  🔐  Automation                      │ ║ ← Card 3
║  │  To execute tasks across multiple   │ ║
║  │  applications automatically          │ ║
║  └─────────────────────────────────────┘ ║
║                                           ║
║       [Grant Permissions]                 ║ ← CTA
║                                           ║
╚═══════════════════════════════════════════╝
```

**Copy**:
- Headline: "Permissions Needed"
- Screen Recording: "To understand what you're working on and provide contextual help"
- Accessibility: "To interact with apps on your behalf (clicking, typing, etc)"
- Automation: "To execute tasks across multiple applications automatically"
- CTA: "Grant Permissions"

**Behavior**:
- Clicking "Grant Permissions" opens System Settings to appropriate panels
- Shows checklist of granted permissions
- "Continue" button only enabled when all permissions granted

---

#### Screen 4: Ready to Go
**Visual**:
- Success state with checkmark
- Reminder of hotkeys
- Launch app button

```
╔═══════════════════════════════════════════╗
║                                           ║
║               ✓                           ║ ← Large checkmark
║                                           ║
║          You're All Set                   ║ ← Headline
║                                           ║
║     Grain is now learning from            ║
║         your desktop activity             ║ ← Subhead
║                                           ║
║  ─────────────────────────────────────   ║
║                                           ║
║         Quick Reference:                  ║
║                                           ║
║    ⌃⎵  Control+Space → Search            ║ ← Hotkey guide
║    ⌥⎵  Option+Space  → Assistant         ║
║    ⌘\  Command+\     → Hide/Show         ║
║                                           ║
║  ─────────────────────────────────────   ║
║                                           ║
║           [Start Using Grain]             ║ ← Launch CTA
║                                           ║
╚═══════════════════════════════════════════╝
```

**Copy**:
- Headline: "You're All Set"
- Subhead: "Grain is now learning from your desktop activity"
- Hotkey reference list
- CTA: "Start Using Grain"

**Behavior**:
- Clicking "Start Using Grain" closes onboarding
- Grain begins background monitoring
- Side icon appears at center-right edge
- Onboarding can be re-accessed via settings menu

---

### Onboarding Design Principles

1. **Glass Theme Consistency**: All onboarding screens use heavy glass blur matching search bar
2. **Progressive Disclosure**: One concept per screen, no overwhelming walls of text
3. **Clear Value Props**: Each screen answers "why does this matter?"
4. **Visual Hierarchy**: Large headers, clear CTAs, readable body text
5. **Animation**: Subtle fade-in transitions between screens (300-400ms)
6. **Skippable**: Advanced users can skip to permissions screen
7. **No Dark Patterns**: Honest about what Grain does, why permissions are needed
8. **Responsive**: Works on all Mac screen sizes (minimum 1280×800)

---

## Implementation Phases

### Phase 1: Foundation + Search Bar + Onboarding (Week 1)
**Goal**: Complete onboarding flow and primary interface

**Onboarding Implementation**:
- [ ] Welcome screen (icon, copy, glass background)
- [ ] How It Works screen (3 panels with icons)
- [ ] Permissions screen (3 cards with explanations)
- [ ] Ready to Go screen (success state + hotkey reference)
- [ ] Screen transition animations (fade + slide)
- [ ] Permission request handlers (open System Settings)
- [ ] Permission status checking
- [ ] Onboarding completion persistence (UserDefaults)

**App Foundation**:
- [ ] Xcode project setup
- [ ] Design system implementation (colors, fonts, components)
- [ ] Glass morphism components (reusable heavy blur containers)
- [ ] Global hotkey registration (Control+Space and Option+Space)
- [ ] App icon integration

**Search Bar UI** (Control+Space):
- [ ] Floating window with heavy glass blur (matching Glass reference)
- [ ] Large centered text input field
- [ ] Listen/Ask/Show-Hide buttons (top control bar)
- [ ] Auto-dismiss on ESC or focus loss
- [ ] Scale + fade entrance animation
- [ ] Keyboard shortcut handling (Cmd+Return, Cmd+\)

### Phase 2: Side Icon (Week 1-2)
**Goal**: Persistent desktop companion

- [ ] Always-on-top window implementation
- [ ] Icon state animations (idle/listening/thinking/acting)
- [ ] Drag-to-reposition functionality (free movement)
- [ ] Position persistence (UserDefaults)
- [ ] Default position: center-right edge
- [ ] Option+Space trigger integration

### Phase 3: Notch Animation (Week 2) **[Optional - Notch Macs Only]**
**Goal**: Hardware-specific enhancement

- [ ] Notch detection (NSScreen.safeAreaInsets check)
- [ ] Graceful fallback for non-notch Macs
- [ ] Idle breathing animation
- [ ] Click interaction (opens main panel)
- [ ] Expand/collapse transitions
- [ ] Active state UI (task name + progress)

### Phase 4: Main Panel UI (Week 2-3)
**Goal**: Professional, functional interface

- [ ] Glass morphism panel design
- [ ] Context awareness display (stubbed data)
- [ ] Action suggestion list
- [ ] Activity log component
- [ ] Panel positioning logic (anchored to notch or cursor)

### Phase 5: Screen Monitoring (Week 3-4)
**Goal**: Passive observation capabilities

- [ ] ScreenCaptureKit integration
- [ ] OCR text extraction (Vision framework)
- [ ] Accessibility tree monitoring
- [ ] Activity logging (local storage)
- [ ] Privacy-safe data handling

### Phase 6: Polish & Optimization (Week 4)
**Goal**: Production-ready frontend

- [ ] Animation performance tuning (60fps target)
- [ ] Memory usage optimization
- [ ] Onboarding flow testing
- [ ] Edge case handling (multiple displays, notch-less Macs)
- [ ] App icon + marketing assets

**Phase 7: Backend Integration** (Future)
- AI model integration (LLM + reinforcement learning)
- Cloud sync for learned behaviors
- Multi-device coordination
- Advanced task automation

---

## Technical Requirements

### macOS APIs & Permissions

```xml
<!-- Info.plist entries -->
<key>NSScreenCaptureUsageDescription</key>
<string>Noir Agent observes your screen to understand context and automate tasks.</string>

<key>NSAccessibilityUsageDescription</key>
<string>Required to interact with applications on your behalf.</string>

<key>NSAppleEventsUsageDescription</key>
<string>Enables automation of repetitive tasks across applications.</string>
```

### Entitlements

```xml
<!-- Entitlements.entitlements -->
<key>com.apple.security.automation.apple-events</key>
<true/>
<key>com.apple.security.personal-information.screen-recording</key>
<true/>
```

### Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| App Launch Time | <1.5s | Time to background service ready |
| Memory (Idle) | <150 MB | Activity Monitor |
| Memory (Active) | <300 MB | During screen capture + OCR |
| CPU (Idle) | <2% | Background monitoring |
| CPU (Active) | <15% | Task execution |
| Animation FPS | 60fps | Instruments profiling |
| Search Bar Response | <50ms | Control+Space to visible |
| Hotkey Latency | <100ms | Input to action trigger |

---

## Design Mockups Reference

### Search Bar (Control + Space) - Glass Style

```
TOP OF SCREEN - CENTERED (~120px from top):

╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║  ┌──────────────────────────────────────────────────────┐    ║
║  │ 🎤 Listen |||   Ask ⌘↵   Show/Hide ⌘ \        ⋮     │    ║ ← Control bar
║  └──────────────────────────────────────────────────────┘    ║
║                                                                ║
║                         Glass                                  ║ ← Large input text
║                           |                                    ║ ← Cursor
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
           ↑ Heavy frosted glass blur + dark tint

ACTIVE (with text):
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║  ┌──────────────────────────────────────────────────────┐    ║
║  │ 🎤 Listen |||   Ask ⌘↵   Show/Hide ⌘ \        ⋮     │    ║
║  └──────────────────────────────────────────────────────┘    ║
║                                                                ║
║           organize my downloads folder                         ║ ← User input
║                                         |                      ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

LISTENING MODE:
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║  ┌──────────────────────────────────────────────────────┐    ║
║  │ 🔴 Listening...   Ask ⌘↵   Show/Hide ⌘ \      ⋮     │    ║ ← Red indicator
║  └──────────────────────────────────────────────────────┘    ║
║                                                                ║
║                  〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️                          ║ ← Waveform
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

### Notch States

```
IDLE:
┌──────────────────────────────────┐
│        [subtle scanning...]       │  ← Grainy, low opacity
└──────────────────────────────────┘

ACTIVE:
┌──────────────────────────────────┐
│  ⚡ Renaming screenshots...       │
│  ████████████░░░░░░░░░░░  73%    │  ← Progress bar
└──────────────────────────────────┘
```

### Side Icon States

```
DORMANT:        LISTENING:      THINKING:       ACTING:
   🕵️              🕵️💭            🕵️🧠            🕵️⚡
  (30%)          (70%)          (90%)          (100%)
 opacity        pulse         processing      execution
```

### Main Panel Layout

```
╔═══════════════════════════════════╗
║  🎬 Grain              [—][×]     ║  ← Glass header (grain icon)
╠═══════════════════════════════════╣
║                                   ║
║  📊 Context Detected:             ║
║  "Excel sheet - Q4 Revenue.xlsx"  ║  ← Awareness card
║                                   ║
╠───────────────────────────────────╣
║  ✨ I can help with:              ║
║  ○ Auto-sum columns              ║
║  ○ Format as currency            ║  ← Action list
║  ○ Create revenue chart          ║
║                                   ║
║  [Approve All] [Customize]       ║  ← CTAs
╠───────────────────────────────────╣
║  Recent Activity ▼                ║
║  • 2m ago: Renamed 5 files       ║
║  • 8m ago: Organized Downloads   ║  ← Activity log
║  • 15m ago: Updated formulas     ║
╚═══════════════════════════════════╝
```

---

## Privacy & Security Principles

### Data Handling
- **All processing happens on-device** (no cloud uploads during frontend phase)
- Screen captures are **temporary** (RAM only, never saved to disk)
- User activity logs are **encrypted** at rest (CryptoKit)
- **No telemetry** without explicit opt-in

### User Control
- Global kill switch (menubar: "Pause Agent")
- Per-app exclusions (e.g., never monitor banking apps)
- Activity history deletion (clear all learned behaviors)
- Transparent logging (user can review everything AI saw)

### Consent Model
- **Explicit approval** required for autonomous actions initially
- Gradual trust building (agent asks less over time)
- Always show "AI did this" notification after autonomous actions
- One-click rollback for any automated task

---

## Success Metrics (Frontend Phase)

**User Experience**:
- [ ] Search bar (Control+Space) appears instantly (<50ms)
- [ ] Glass morphism renders beautifully on all wallpapers
- [ ] Voice input transcription is accurate (>95%)
- [ ] Side icon is draggable with smooth 60fps motion
- [ ] Notch animation (on supported Macs) runs at 60fps
- [ ] UI feels "Apple-grade" professional (no jank, no bugs)
- [ ] Onboarding completion rate >80% (internal testing)

**Technical**:
- [ ] Zero crashes during 1-hour continuous use
- [ ] Memory footprint stable (no leaks)
- [ ] Works across all Mac models (M1/M2/M3, notch and non-notch)
- [ ] Clean Xcode build (0 warnings)
- [ ] Search bar dismisses properly (ESC, click outside, focus loss)

**Aesthetic**:
- [ ] Noir/grain theme is cohesive across all UI elements
- [ ] Glass morphism matches reference screenshot quality
- [ ] Film grain effect is subtle but noticeable
- [ ] Animations feel purposeful, not decorative
- [ ] Typography is crisp and readable at all sizes

---

## Known Limitations & Future Work

### Current Scope (Frontend Only)
- No actual AI autonomy (stubbed behavior)
- No learning from user actions (fake suggestions)
- No task execution (UI only)
- No multi-device sync

### Post-Frontend Goals
- LLM integration for natural language understanding
- Reinforcement learning for behavior adaptation
- AppleScript/Shortcuts execution engine
- Cloud sync for learned workflows
- iOS companion app (iPhone/iPad control)

---

## Questions for Team Alignment

Before starting development, clarify:

1. **Voice Input Backend**: Which speech-to-text service? (Apple's built-in Speech framework, or third-party like Deepgram/AssemblyAI for better accuracy?)
2. **Search Bar Persistence**: Should search bar remember recent queries for quick access?
3. **Privacy Dashboard**: Build in-app settings or use System Settings for permission management?
4. **Fallback Behavior**: What happens when AI is uncertain? (Ask user via search bar vs. do nothing vs. show notification)
5. **Side Icon Snapping**: Should dragging snap to grid/edges, or allow free positioning anywhere?

---

## Getting Started

### Prerequisites
```bash
# Install Xcode 15.0+
xcode-select --install

# Install SwiftLint (optional, for code quality)
brew install swiftlint

# Clone project (once repo created)
git clone [repository-url]
cd Grain
```

### First Build
```bash
# Open in Xcode
open Grain.xcodeproj

# Build and run (Cmd+R)
# Grant permissions when prompted
# Test Control+Space for search bar
# Test Option+Space for side icon + panel
```

### Development Workflow
1. Create feature branch: `git checkout -b feature/search-bar-ui`
2. Implement component from Phase checklist
3. Test on physical Mac (with and without notch)
4. Record screen demo showing feature
5. Submit PR with demo video

---

## Resources

**Design Inspiration**:
- **Glass UI** (https://github.com/pickle-com/glass) - PRIMARY REFERENCE for search bar
- Arc Browser's Command Bar (glass UI secondary reference)
- Raycast (hotkey interaction + search UX)
- macOS Spotlight (search bar positioning)
- Cleanshot X (floating UI overlay patterns)
- Detective noir films (aesthetic reference)
- Linear app (modern glass UI patterns)

**Technical References**:
- [Apple ScreenCaptureKit Docs](https://developer.apple.com/documentation/screencapturekit)
- [Accessibility Programming Guide](https://developer.apple.com/library/archive/documentation/Accessibility/Conceptual/AccessibilityMacOSX/)
- [SwiftUI Glass Morphism Tutorial](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-glass-morphism-effect)
- [AVFoundation Speech Recognition](https://developer.apple.com/documentation/speech)

**Community**:
- r/macapps (for feedback on Mac app UX)
- Swift Forums (for technical questions)

---

**Last Updated**: January 31, 2026  
**Document Owner**: Development Team  
**Status**: Active Development - Frontend Phase  
**Next Milestone**: Phase 1 Complete (Search Bar + Foundation)
