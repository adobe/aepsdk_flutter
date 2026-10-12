// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_aepoptimize",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-aepoptimize", targets: ["flutter_aepoptimize"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/adobe/aepsdk-optimize-ios.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepoptimize",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPOptimize", package: "aepsdk-optimize-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepoptimize")
            ]
        )
    ]
)
