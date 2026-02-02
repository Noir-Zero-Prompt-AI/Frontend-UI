#!/bin/bash

# Grain - Run in Xcode Script
# This script helps you quickly set up and run Grain in Xcode

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Grain App - Xcode Launch Helper                     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

echo "⚠️  The Grain app needs to run in Xcode for full functionality"
echo ""
echo "Swift Package Manager builds command-line tools, but Grain needs:"
echo "  • Proper SwiftUI window management"
echo "  • macOS app bundle structure"
echo "  • Code signing and entitlements"
echo "  • Asset catalog support"
echo ""

echo "📋 Quick Setup (5 minutes):"
echo ""
echo "1. Open Xcode:"
echo "   $ open /Applications/Xcode.app"
echo ""
echo "2. Create new project:"
echo "   File → New → Project"
echo "   Choose: macOS → App"
echo "   Name: Grain"
echo "   Interface: SwiftUI"
echo "   Language: Swift"
echo ""
echo "3. Add source files:"
echo "   Delete default GrainApp.swift and ContentView.swift"
echo "   Drag these folders into Xcode:"
echo "     • Grain/Grain/App/"
echo "     • Grain/Grain/Views/"
echo "     • Grain/Grain/Components/"
echo "     • Grain/Grain/Core/"
echo "     • Grain/Grain/Design/"
echo "   Uncheck 'Copy items if needed'"
echo ""
echo "4. Configure:"
echo "   - Set deployment target to macOS 14.0"
echo "   - Add permission keys to Info.plist"
echo "   - Disable App Sandbox in Signing & Capabilities"
echo ""
echo "5. Build and Run:"
echo "   Press ⌘R"
echo ""
echo "📚 Full instructions: See SETUP.md"
echo ""

read -p "Press Enter to open Xcode, or Ctrl+C to cancel..."

open /Applications/Xcode.app

echo ""
echo "✅ Xcode opened! Follow the steps above to create your project."
echo ""
