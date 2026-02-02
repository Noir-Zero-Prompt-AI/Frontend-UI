#!/bin/bash

# Create Xcode project directory
mkdir -p "Grain.xcodeproj"

# Create project.pbxproj file
cat > "Grain.xcodeproj/project.pbxproj" << 'PBXPROJ'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {
		mainGroup = {
			isa = PBXGroup;
			children = (
				"Grain"
			);
			sourceTree = "<group>";
		};
	};
	rootObject = "PROJECT_REF";
}
PBXPROJ

echo "Xcode project structure created"
