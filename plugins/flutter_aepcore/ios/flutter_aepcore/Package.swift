// swift-tools-version: 5.9
/*
Copyright 2026 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import PackageDescription

let package = Package(
    name: "flutter_aepcore",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "flutter-aepcore", targets: ["flutter_aepcore"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/adobe/aepsdk-core-ios.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(
            name: "flutter_aepcore",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "AEPCore", package: "aepsdk-core-ios"),
                .product(name: "AEPServices", package: "aepsdk-core-ios"),
                .product(name: "AEPIdentity", package: "aepsdk-core-ios"),
                .product(name: "AEPLifecycle", package: "aepsdk-core-ios"),
                .product(name: "AEPSignal", package: "aepsdk-core-ios")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_aepcore")
            ]
        )
    ]
)
