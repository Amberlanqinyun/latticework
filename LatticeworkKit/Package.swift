// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LatticeworkKit",
    platforms: [.macOS(.v12), .iOS(.v17)],
    products: [
        .library(name: "LatticeworkKit", targets: ["LatticeworkKit"])
    ],
    targets: [
        .target(
            name: "LatticeworkKit",
            resources: [.process("Resources/models.json")]
        ),
        // XCTest suites — run with `swift test` under full Xcode / CI.
        .testTarget(
            name: "LatticeworkKitTests",
            dependencies: ["LatticeworkKit"]
        ),
        // Dependency-free runner — `swift run Verify` works with Command Line Tools
        // only (no XCTest needed). Mirrors the XCTest coverage for headless checks.
        .executableTarget(
            name: "Verify",
            dependencies: ["LatticeworkKit"]
        )
    ]
)
