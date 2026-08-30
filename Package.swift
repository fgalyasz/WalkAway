// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WalkAway",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "WalkAwayCore", targets: ["WalkAwayCore"]),
        .executable(name: "WalkAway", targets: ["WalkAway"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.7.0")
    ],
    targets: [
        .target(name: "WalkAwayCore", dependencies: []),
        .executableTarget(
            name: "WalkAway",
            dependencies: [
                "WalkAwayCore",
                .product(name: "Sparkle", package: "Sparkle")
            ],
            path: "Sources/WalkAway"
        ),
        .testTarget(
            name: "WalkAwayCoreTests",
            dependencies: ["WalkAwayCore"]
        )
    ]
)
