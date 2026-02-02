#!/bin/bash

# Grain Setup Verification Script
# Checks that all necessary files are in place

echo "🔍 Verifying Grain project setup..."
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
FOUND=0
MISSING=0

check_file() {
    local file=$1
    local category=$2
    TOTAL=$((TOTAL + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $category: $(basename $file)"
        FOUND=$((FOUND + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $category: $(basename $file) ${RED}[MISSING]${NC}"
        MISSING=$((MISSING + 1))
        return 1
    fi
}

check_dir() {
    local dir=$1
    local name=$2
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} Directory: $name"
        return 0
    else
        echo -e "${RED}✗${NC} Directory: $name ${RED}[MISSING]${NC}"
        return 1
    fi
}

# Check directory structure
echo "📁 Directory Structure:"
check_dir "Grain/Grain" "Main source directory"
check_dir "Grain/Grain/App" "App directory"
check_dir "Grain/Grain/Views" "Views directory"
check_dir "Grain/Grain/Components" "Components directory"
check_dir "Grain/Grain/Core" "Core directory"
check_dir "Grain/Grain/Design" "Design directory"
echo ""

# Check App files
echo "🚀 App Files:"
check_file "Grain/Grain/App/GrainApp.swift" "App"
check_file "Grain/Grain/App/AppDelegate.swift" "App"
check_file "Grain/Grain/App/Permissions.swift" "App"
echo ""

# Check Design files
echo "🎨 Design System:"
check_file "Grain/Grain/Design/NoirColors.swift" "Design"
check_file "Grain/Grain/Design/NoirFonts.swift" "Design"
check_file "Grain/Grain/Design/AnimationCurves.swift" "Design"
echo ""

# Check Components
echo "🧩 Components:"
check_file "Grain/Grain/Components/GlassCard.swift" "Component"
check_file "Grain/Grain/Components/GrainOverlay.swift" "Component"
check_file "Grain/Grain/Components/NoirButton.swift" "Component"
check_file "Grain/Grain/Components/NoirTextField.swift" "Component"
echo ""

# Check Core files
echo "⚙️  Core Files:"
check_file "Grain/Grain/Core/HotkeyManager.swift" "Core"
check_file "Grain/Grain/Core/ScreenObserver.swift" "Core"
check_file "Grain/Grain/Core/AgentBrain.swift" "Core"
echo ""

# Check Onboarding views
echo "📱 Onboarding Views:"
check_file "Grain/Grain/Views/Onboarding/OnboardingFlow.swift" "View"
check_file "Grain/Grain/Views/Onboarding/OnboardingViewModel.swift" "View"
check_file "Grain/Grain/Views/Onboarding/WelcomeScreen.swift" "View"
check_file "Grain/Grain/Views/Onboarding/HowItWorksScreen.swift" "View"
check_file "Grain/Grain/Views/Onboarding/PermissionsScreen.swift" "View"
check_file "Grain/Grain/Views/Onboarding/ReadyScreen.swift" "View"
echo ""

# Check SearchBar views
echo "🔍 Search Bar Views:"
check_file "Grain/Grain/Views/SearchBar/SearchBarWindow.swift" "View"
check_file "Grain/Grain/Views/SearchBar/SearchBarView.swift" "View"
echo ""

# Check SideIcon views
echo "👤 Side Icon Views:"
check_file "Grain/Grain/Views/SideIcon/SideIconWindow.swift" "View"
check_file "Grain/Grain/Views/SideIcon/SideIconView.swift" "View"
echo ""

# Check NotchAnimation views
echo "📍 Notch Animation Views:"
check_file "Grain/Grain/Views/NotchAnimation/NotchDetector.swift" "View"
check_file "Grain/Grain/Views/NotchAnimation/NotchView.swift" "View"
echo ""

# Check MainPanel views
echo "🎛️  Main Panel Views:"
check_file "Grain/Grain/Views/MainPanel/MainPanelView.swift" "View"
echo ""

# Check configuration files
echo "⚙️  Configuration Files:"
check_file "Grain/Grain/Info.plist" "Config"
check_file "Grain/Grain/Grain.entitlements" "Config"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "📊 Summary:"
echo -e "   Total files checked: $TOTAL"
echo -e "   ${GREEN}Found: $FOUND${NC}"
if [ $MISSING -gt 0 ]; then
    echo -e "   ${RED}Missing: $MISSING${NC}"
else
    echo -e "   ${GREEN}Missing: 0${NC}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Swift version
echo "🛠️  Environment Check:"
if command -v swift &> /dev/null; then
    SWIFT_VERSION=$(swift --version | head -n 1)
    echo -e "${GREEN}✓${NC} Swift: $SWIFT_VERSION"
else
    echo -e "${RED}✗${NC} Swift not found in PATH"
fi

if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    echo -e "${GREEN}✓${NC} Xcode: $XCODE_VERSION"
else
    echo -e "${RED}✗${NC} Xcode command line tools not found"
fi
echo ""

# Final recommendations
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✅ All files present!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open Xcode and create a new macOS App project"
    echo "2. Follow instructions in SETUP.md"
    echo "3. Add all source files to your Xcode project"
    echo "4. Build and run (⌘R)"
else
    echo -e "${YELLOW}⚠️  Some files are missing!${NC}"
    echo ""
    echo "Please ensure all files are created before proceeding."
fi

echo ""
echo "📚 For detailed setup instructions, see: SETUP.md"
echo "📖 For project overview, see: README.md"
echo ""
