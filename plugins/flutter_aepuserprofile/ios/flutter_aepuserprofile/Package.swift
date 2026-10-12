// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_aepuserprofile",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "flutter-aepuserprofile", targets: ["flutter_aepuserprofile"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/adobe/aepsdk-userprofile-ios.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepuserprofile",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPUserProfile", package: "aepsdk-userprofile-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepuserprofile")
            ]
        )
    ]
)
