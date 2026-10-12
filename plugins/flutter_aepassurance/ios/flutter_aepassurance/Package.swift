// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_aepassurance",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-aepassurance", targets: ["flutter_aepassurance"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/adobe/aepsdk-assurance-ios.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepassurance",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPAssurance", package: "aepsdk-assurance-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepassurance")
            ]
        )
    ]
)
