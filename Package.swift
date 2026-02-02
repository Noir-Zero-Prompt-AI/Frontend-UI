// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Grain",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "Grain",
            targets: ["Grain"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "Grain",
            dependencies: [],
            path: "Grain/Grain",
            exclude: ["Assets.xcassets", "Info.plist", "Grain.entitlements"],
            sources: [
                "App",
                "Design",
                "Components",
                "Core",
                "Views"
            ]
        )
    ]
)
