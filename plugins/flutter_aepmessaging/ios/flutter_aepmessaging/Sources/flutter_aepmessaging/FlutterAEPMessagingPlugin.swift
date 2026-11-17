/*
Copyright 2026 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance with the License. You
may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
REPRESENTATIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/
import Flutter
import Foundation

// Entry point referenced by `pluginClass` in pubspec.yaml. Implemented in Swift (instead of an
// Objective-C shim) because Swift Package Manager targets cannot mix Swift and Objective-C sources.
public class FlutterAEPMessagingPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftFlutterAEPMessagingPlugin.register(with: registrar)
    }
}
