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
    targets: [
        .target(name: "WalkAwayCore", dependencies: []),
        .executableTarget(
            name: "WalkAway",
            dependencies: ["WalkAwayCore"],
            path: "Sources/WalkAway"
        ),
        .testTarget(
            name: "WalkAwayCoreTests",
            dependencies: ["WalkAwayCore"]
        )
    ]
)
