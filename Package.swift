// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "aepsdk_flutter",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "flutter_aepcore", targets: ["flutter_aepcore"]),
        .library(name: "flutter_aepassurance", targets: ["flutter_aepassurance"]),
        .library(name: "flutter_aepedge", targets: ["flutter_aepedge"]),
        .library(name: "flutter_aepedgebridge", targets: ["flutter_aepedgebridge"]),
        .library(name: "flutter_aepedgeconsent", targets: ["flutter_aepedgeconsent"]),
        .library(name: "flutter_aepedgeidentity", targets: ["flutter_aepedgeidentity"]),
        .library(name: "flutter_aepmessaging", targets: ["flutter_aepmessaging"]),
        .library(name: "flutter_aepoptimize", targets: ["flutter_aepoptimize"]),
        .library(name: "flutter_aepuserprofile", targets: ["flutter_aepuserprofile"]),
    ],
    dependencies: [
        // External Adobe SDKs
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", from: "5.4.0"),
        .package(url: "https://github.com/adobe/aepsdk-assurance-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-edge-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-edgebridge-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-edgeconsent-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-edgeidentity-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-messaging-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-optimize-ios.git", from: "5.0.0"),
        .package(url: "https://github.com/adobe/aepsdk-userprofile-ios.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "flutter_aepcore",
            dependencies: [
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPLifecycle", package: "aepsdk-core-ios"),
                .product(name: "AEPIdentity", package: "aepsdk-core-ios"),
                .product(name: "AEPSignal", package: "aepsdk-core-ios")
            ],
            path: "plugins/flutter_aepcore/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepassurance",
            dependencies: [
                .product(name: "AEPAssurance", package: "aepsdk-assurance-ios")
            ],
            path: "plugins/flutter_aepassurance/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepedge",
            dependencies: [
                .product(name: "AEPEdge", package: "aepsdk-edge-ios")
            ],
            path: "plugins/flutter_aepedge/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepedgebridge",
            dependencies: [
                .product(name: "AEPEdgeBridge", package: "aepsdk-edgebridge-ios")
            ],
            path: "plugins/flutter_aepedgebridge/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepedgeconsent",
            dependencies: [
                .product(name: "AEPEdgeConsent", package: "aepsdk-edgeconsent-ios")
            ],
            path: "plugins/flutter_aepedgeconsent/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepedgeidentity",
            dependencies: [
                .product(name: "AEPEdgeIdentity", package: "aepsdk-edgeidentity-ios")
            ],
            path: "plugins/flutter_aepedgeidentity/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepmessaging_objc",
            dependencies: [
                .product(name: "AEPMessaging", package: "aepsdk-messaging-ios"),
                .product(name: "AEPCore", package: "aepsdk-core-ios")
            ],
            path: "plugins/flutter_aepmessaging/ios/Classes/ObjC",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepmessaging",
            dependencies: [
                "flutter_aepmessaging_objc"
            ],
            path: "plugins/flutter_aepmessaging/ios/Classes/Swift"
        ),
        .target(
            name: "flutter_aepoptimize",
            dependencies: [
                .product(name: "AEPOptimize", package: "aepsdk-optimize-ios")
            ],
            path: "plugins/flutter_aepoptimize/ios/Classes",
            publicHeadersPath: "."
        ),
        .target(
            name: "flutter_aepuserprofile",
            dependencies: [
                .product(name: "AEPUserProfile", package: "aepsdk-userprofile-ios")
            ],
            path: "plugins/flutter_aepuserprofile/ios/Classes",
            publicHeadersPath: "."
        ),
    ]
)
