# Grain UI Preview Guide

## 🎨 Visual Overview

### Color Palette (Noir Theme)

```
█████ #0A0A0A  Shadow Black   (Deep shadows)
█████ #1C1C1C  Charcoal Gray  (Primary background)
█████ #3A3A3A  Smoke Gray     (Secondary elements)
█████ #6B6B6B  Fog Gray       (Tertiary/disabled)
█████ #E8E8E8  Paper White    (Text/highlights)
```

---

## 1️⃣ Onboarding Flow (4 Screens)

### Screen 1: Welcome
```
╔═══════════════════════════════════════════╗
║                                           ║
║              👤 (Detective Icon)          ║
║                                           ║
║                 Grain                     ║
║                                           ║
║        Zero Prompt AI for macOS           ║
║                                           ║
║      I learn from your actions and        ║
║        help before you even ask.          ║
║                                           ║
║          [Get Started] ←───────────       ║
║                                           ║
║         Skip to permissions               ║
║                                           ║
╚═══════════════════════════════════════════╝
    Heavy glass background with grain
```

### Screen 2: How It Works
```
╔═══════════════════════════════════════════╗
║          How Grain Works                  ║
║                                           ║
║   ┌─────┐   ┌─────┐   ┌─────┐           ║
║   │ ⌃⎵  │   │ ⌥⎵  │   │ ⚡  │           ║
║   └─────┘   └─────┘   └─────┘           ║
║                                           ║
║   Search    Assistant  Automatic          ║
║                                           ║
║  Control+    Option+   I learn your       ║
║   Space      Space     patterns and       ║
║  for quick  for full   work without       ║
║  commands    panel     being asked        ║
║                                           ║
║   [Back]          [Continue]              ║
╚═══════════════════════════════════════════╝
```

### Screen 3: Permissions
```
╔═══════════════════════════════════════════╗
║        Permissions Needed                 ║
║                                           ║
║  ┌───────────────────────────────────┐   ║
║  │ 🖥️  Screen Recording      [✓]    │   ║
║  │ To understand what you're         │   ║
║  │ working on and provide help       │   ║
║  └───────────────────────────────────┘   ║
║                                           ║
║  ┌───────────────────────────────────┐   ║
║  │ ♿️  Accessibility         [⚠]    │   ║
║  │ To interact with apps on          │   ║
║  │ your behalf                [Grant]│   ║
║  └───────────────────────────────────┘   ║
║                                           ║
║  ┌───────────────────────────────────┐   ║
║  │ 🔐  Automation            [⚠]    │   ║
║  │ To execute tasks across apps      │   ║
║  │                            [Grant]│   ║
║  └───────────────────────────────────┘   ║
║                                           ║
║   [Back]    [Grant Permissions]           ║
╚═══════════════════════════════════════════╝
```

### Screen 4: Ready
```
╔═══════════════════════════════════════════╗
║                                           ║
║               ✓  (Checkmark)              ║
║                                           ║
║          You're All Set                   ║
║                                           ║
║      Grain is now learning from           ║
║        your desktop activity              ║
║                                           ║
║  ─────────────────────────────────────   ║
║                                           ║
║         Quick Reference:                  ║
║                                           ║
║    ⌃⎵  Control+Space → Search            ║
║    ⌥⎵  Option+Space  → Assistant         ║
║    ⌘\  Command+\     → Hide/Show         ║
║                                           ║
║  ─────────────────────────────────────   ║
║                                           ║
║       [Start Using Grain]                 ║
║                                           ║
╚═══════════════════════════════════════════╝
```

---

## 2️⃣ Search Bar (Control+Space)

**Appearance**: Top-center of screen, 800px wide

```
                  ┌─ Floating at top of screen ─┐
                  
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ┌────────────────────────────────────────────────────────┐  ║
║  │ 🎤 Listen |||   Ask ⌘↵   Show/Hide ⌘\        ⋮      │  ║
║  └────────────────────────────────────────────────────────┘  ║
║                                                               ║
║                         Glass                                 ║ ← Large input
║                           |                                   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
         ↑ Heavy glass blur + dark tint + grain overlay

**Listening Mode**:
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║  ┌────────────────────────────────────────────────────────┐  ║
║  │ 🔴 Listening...   Ask ⌘↵   Show/Hide ⌘\       ⋮     │  ║
║  └────────────────────────────────────────────────────────┘  ║
║                                                               ║
║                  〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️                          ║ ← Waveform
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 3️⃣ Side Icon (Option+Space)

**Location**: Default center-right edge (draggable)

```
                                            ┌──┐
                                            │👤│ ← Dormant (30% opacity)
                                            └──┘
                                                   
     States:
     
     👤 Dormant     (30% opacity, static)
     👤 Listening   (70% opacity, pulsing)
     👤 Thinking    (90% opacity, rotating)
     👤 Acting      (100% opacity, scaled 1.1x)
     
     Click to open Main Panel
     Drag to reposition
```

---

## 4️⃣ Main Panel

**Size**: 400×600px, right side of screen

```
╔═══════════════════════════════════════╗
║  👤 Grain                        [×]  ║ ← Header
╟───────────────────────────────────────╢
║                                       ║
║  📊 Context Detected:                 ║
║  ┌─────────────────────────────────┐ ║
║  │ "I noticed you're working on    │ ║
║  │  the Q4 presentation..."        │ ║
║  └─────────────────────────────────┘ ║
║                                       ║
║  ✨ I can help with:                 ║
║  ○ Format charts consistently        ║
║  ○ Update revenue projections        ║
║  ○ Check spelling & grammar          ║
║                                       ║
║  [Approve All] [Customize]            ║
║                                       ║
║  Recent Activity ▼                    ║
║  • 2m ago: Renamed 3 files           ║
║  • 8m ago: Updated Excel formulas    ║
║  • 15m ago: Organized downloads      ║
║                                       ║
╚═══════════════════════════════════════╝
    ↑ Glass morphism with scroll
```

---

## 5️⃣ Notch Animation (MacBook Pro 14"/16" Only)

### Idle State
```
   Screen Top Edge
   ┌────────────────────────────────┐
   │     [subtle breathing...]      │ ← Grainy, low opacity
   └────────────────────────────────┘
          Notch Area
```

### Active State
```
   Screen Top Edge
   ┌────────────────────────────────┐
   │  ⚡ Renaming screenshots...     │
   │  ████████████░░░░░░░░░  73%   │ ← Progress bar
   └────────────────────────────────┘
```

---

## 🎬 Animation Examples

### Search Bar Appearance (Control+Space)
```
Time: 0ms      100ms     200ms     300ms
      ↓         ↓         ↓         ↓
Scale: 0.95 → 0.97 → 0.99 → 1.0
Alpha: 0.0  → 0.5  → 0.8  → 1.0

Easing: Spring (response: 0.3, damping: 0.8)
```

### Side Icon State Transition
```
Dormant → Listening: 0.4s ease-in-out
  Opacity: 0.3 → 0.7
  Glow: none → white radial gradient
  
Listening → Thinking: 0.4s ease-in-out
  Opacity: 0.7 → 0.9
  Animation: pulse → rotation (360° in 2s)
  
Thinking → Acting: 0.4s ease-in-out
  Opacity: 0.9 → 1.0
  Scale: 1.0 → 1.1
```

### Glass Card Effect Breakdown
```
Layer Stack (bottom to top):

1. Content                     ← Your UI
2. .ultraThickMaterial         ← Heavy system blur
3. Dark gradient overlay       ← Black 0.3 → 0.2 alpha
4. Rounded rectangle clip      ← cornerRadius: 24
5. Stroke border              ← White 0.2 alpha, 1.5px
6. Shadow                     ← Black 0.4 alpha, radius: 30
7. Film grain overlay         ← Noise pattern, 0.08 alpha
```

---

## 📐 Layout Specifications

### Search Bar
- **Width**: 800px
- **Height**: 150px (170px when listening)
- **Position**: Top-center, 100-150px from top edge
- **Font Size**: 52pt (input text)
- **Corner Radius**: 24px

### Side Icon
- **Width**: 80px
- **Height**: 80px
- **Icon Size**: 50×50px (within 80×80 container)
- **Default Position**: Center-right, 100px from right edge

### Main Panel
- **Width**: 400px
- **Height**: 600px
- **Position**: Right side, 20px from right edge
- **Corner Radius**: 20px
- **Padding**: 20px internal

### Notch (if detected)
- **Width**: 200px (approximate)
- **Height**: 30px (idle), expands to 80px (active)
- **Position**: Top-center of screen

---

## 🎨 Typography Scale

```
Display:  52pt  (Search bar input)
Title:    36pt  (Onboarding headlines)
Large:    32pt  (Welcome screen title)
H1:       18pt  (Section headers)
Body:     16pt  (Default text)
Caption:  14pt  (Control bar buttons)
Small:    13pt  (Suggestions list)
Micro:    11pt  (Activity timestamps)
```

---

## 🌈 Glass Effects

### Heavy Glass (Primary)
```swift
.background(.ultraThickMaterial)
.background(LinearGradient(/* dark tint */))
.overlay(RoundedRectangle(/* border */))
.shadow(/* large shadow */)
```

Visual: Almost opaque blur with dark tint

### Medium Glass (Secondary)
```swift
.background(.ultraThinMaterial)
.background(Color.black.opacity(0.3))
```

Visual: Lighter blur, used for notch active state

### Film Grain
```swift
FilmGrainOverlay(opacity: 0.08)
```

Visual: Procedural noise pattern, subtle texture

---

## 📱 Interaction States

### Buttons
```
Normal:    Gray background, white text
Hover:     Slight brightness increase
Active:    Scale 0.95x
Disabled:  50% opacity
```

### Text Fields
```
Idle:      Dark gray background
Focus:     Border brightens (0.15 → 0.3 alpha)
Typing:    Cursor visible, text white 0.9 alpha
```

### Windows
```
Open:      Fade + scale (0.95 → 1.0, 300ms)
Close:     Fade out (200ms ease-in)
Drag:      Follows cursor smoothly (no delay)
```

---

## 🎯 Design Principles Applied

1. **Heavy Glass**: Not subtle - bold blur effect
2. **Noir Aesthetic**: Monochromatic, high contrast
3. **Film Grain**: Subtle texture (8% opacity max)
4. **Professional Pace**: 0.3-0.5s animations
5. **Purposeful Motion**: Every animation conveys state
6. **Context-Agnostic**: Works on any background
7. **Accessibility**: High contrast, clear hierarchy

---

## 💡 Preview Tips

To see these UIs in action:

1. **SwiftUI Previews**: Open any view file, press `Opt+Cmd+Return`
2. **Live Build**: Run the app (⌘R) and trigger each component
3. **Test Backgrounds**: Change your wallpaper to test glass effect
4. **Notch Testing**: Only visible on MacBook Pro 14"/16"

---

**All UI components use SwiftUI with heavy glass morphism and film noir aesthetic.**

Built for **macOS 13.0+** with **modern SwiftUI APIs**.
