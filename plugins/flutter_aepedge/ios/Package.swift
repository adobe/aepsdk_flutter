// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "flutter_aepedge",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "flutter_aepedge",
            targets: ["flutter_aepedge"])
    ],
    dependencies: [
        .package(name: "AEPEdge", url: "https://github.com/adobe/aepsdk-edge-ios.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "flutter_aepedge",
            dependencies: [
                .product(name: "AEPEdge", package: "AEPEdge")
            ],
            path: "Classes",
            publicHeadersPath: "."
        )
    ]
)
