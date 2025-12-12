// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LinkDetectore",
    platforms: [
        .iOS(.v14),      // Choose your minimum supported iOS version
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LinkDetectore",
            targets: ["LinkDetectore"]
        )
    ],
    targets: [
        .target(
            name: "LinkDetectore",
            dependencies: []
        ),
        .testTarget(
            name: "LinkDetectoreTests",
            dependencies: ["LinkDetectore"]
        )
    ]
)
