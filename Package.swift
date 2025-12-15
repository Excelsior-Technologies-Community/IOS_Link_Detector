// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LinkDetector",
    platforms: [
        .iOS(.v14),      // Choose your minimum supported iOS version
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LinkDetector",
            targets: ["LinkDetector"]
        )
    ],
    targets: [
        .target(
            name: "LinkDetector",
            dependencies: []
        ),
        .testTarget(
            name: "LinkDetectoreTests",
            dependencies: ["LinkDetector"]
        )
    ]
)
