// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_aepedgebridge",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-aepedgebridge", targets: ["flutter_aepedgebridge"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-edgebridge-ios.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepedgebridge",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPEdgeBridge", package: "aepsdk-edgebridge-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepedgebridge")
            ]
        )
    ]
)
