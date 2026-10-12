// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_aepcore",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-aepcore", targets: ["flutter_aepcore"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", .upToNextMajor(from: "5.4.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepcore",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPIdentity", package: "aepsdk-core-ios"),
                .product(name: "AEPLifecycle", package: "aepsdk-core-ios"),
                .product(name: "AEPServices", package: "aepsdk-core-ios"),
                .product(name: "AEPSignal", package: "aepsdk-core-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepcore")
            ]
        )
    ]
)
