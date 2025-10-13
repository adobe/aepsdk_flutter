import AEPCore
import AEPMessaging
import AEPServices
import Flutter
import Foundation
import UIKit
import UserNotifications
import WebKit

public class SwiftFlutterAEPMessagingPlugin: NSObject, FlutterPlugin, MessagingDelegate {
    private let channel: FlutterMethodChannel
    private let dataBridge: SwiftFlutterAEPMessagingDataBridge
    private var messageCache = [String: Message]()

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        dataBridge = SwiftFlutterAEPMessagingDataBridge()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_aepmessaging",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftFlutterAEPMessagingPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        MobileCore.messagingDelegate = instance
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        // Messaging Methods
        case "extensionVersion":
            return result(Messaging.extensionVersion)
        case "getCachedMessages":
            return result(getCachedMessages())
        case "refreshInAppMessages":
            Messaging.refreshInAppMessages()
            return result(nil)
        // Message Methods
        case "clearMessage":
            return result(clearMessage(arguments: call.arguments))
        case "dismissMessage":
            return result(dismissMessage(arguments: call.arguments))
        case "setAutoTrack":
            return result(setAutoTrack(arguments: call.arguments))
        case "showMessage":
            return result(showMessage(arguments: call.arguments))
        case "trackMessage":
            return result(trackMessage(arguments: call.arguments))
        default:
            return result(FlutterMethodNotImplemented)
        }
    }

    private func getCachedMessages() -> [[String: Any]] {
        let cachedMessages = messageCache.values.map {
            dataBridge.transformToFlutterMessage(message: $0)
        }
        return cachedMessages
    }

    // Message Class Methods
    private func clearMessage(arguments: Any?) -> FlutterError? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String
        {
            let msg = messageCache[id]
            if msg != nil {
                messageCache.removeValue(forKey: msg!.id)
                return nil
            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: "No Message ID was supplied",
            details: nil
        )
    }

    private func dismissMessage(arguments: Any?) -> FlutterError? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String,
            let suppressAutoTrack = args["suppressAutoTrack"] as? Bool
        {
            let msg = messageCache[id]
            if msg != nil {
                msg!.dismiss(suppressAutoTrack: suppressAutoTrack)
                return nil

            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: "No Message ID was supplied",
            details: nil
        )
    }

    private func setAutoTrack(arguments: Any?) -> FlutterError? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String,
            let autoTrack = args["autoTrack"] as? Bool
        {
            let msg = messageCache[id]
            if msg != nil {
                msg!.autoTrack = autoTrack
                return nil

            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: "No Message ID was supplied",
            details: nil
        )
    }

    private func showMessage(arguments: Any?) -> FlutterError? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String
        {
            let msg = messageCache[id]
            if msg != nil {
                msg!.show()
                return nil
            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: "No Message ID was supplied",
            details: nil
        )
    }

    private func trackMessage(arguments: Any?) -> FlutterError? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String,
            let interaction = args["interaction"] as? String,
            let eventType = args["eventType"] as? Int
        {
            let msg = messageCache[id]
            let eventType =
                MessagingEdgeEventType.init(rawValue: eventType)
                ?? MessagingEdgeEventType.dismiss
            if msg != nil {
                msg!.track(interaction, withEdgeEventType: eventType)
                return nil
            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: "No Message ID was supplied",
            details: nil
        )
    }

    // Messaging Delegate Methods
    public func onDismiss(message: Showable) {
        if let fullscreenMessage = message as? FullscreenMessage,
           let parentMessage = fullscreenMessage.parent
        {
            DispatchQueue.main.async {
                self.channel.invokeMethod(
                    "onDismiss",
                    arguments: [
                        "message": self.dataBridge.transformToFlutterMessage(
                            message: parentMessage
                        )
                    ]
                )
            }
        }
    }

    public func onShow(message: Showable) {
        if let fullscreenMessage = message as? FullscreenMessage,
           let parentMessage = fullscreenMessage.parent
        {
            DispatchQueue.main.async {
                self.channel.invokeMethod(
                    "onShow",
                    arguments: [
                        "message": self.dataBridge.transformToFlutterMessage(
                            message: parentMessage
                        )
                    ]
                )
            }
        }
    }

    public func shouldShowMessage(message: Showable) -> Bool {
        if let fullscreenMessage = message as? FullscreenMessage,
           let incomingMessage = fullscreenMessage.parent
        {
            var shouldSave = true  // Default to true for fallback
            var shouldShow = true  // Default to true for fallback
            let semaphore = DispatchSemaphore(value: 0)
            let timeout = DispatchTime.now() + .milliseconds(500) // 500ms timeout
            
            DispatchQueue.main.async {
                self.channel.invokeMethod(
                    "shouldSaveMessage",
                    arguments: [
                        "message": self.dataBridge.transformToFlutterMessage(
                            message: incomingMessage
                        )
                    ],
                    result: { (result: Any?) -> Void in
                        if let shouldSaveMessage = result as? Bool {
                            shouldSave = shouldSaveMessage
                        }
                        // If no Flutter handler is registered, result will be FlutterMethodNotImplemented
                        // In that case, we keep the default shouldSave = true
                        semaphore.signal()
                    }
                )
            }

            // Wait with timeout - if Flutter handler isn't available, don't wait forever
            if semaphore.wait(timeout: timeout) == .timedOut {
                // Timeout occurred - Flutter handler likely not registered, use fallback
                shouldSave = true
            }
            
            // Cache the message if shouldSave is true (either from Flutter or fallback)
            if shouldSave {
                self.messageCache[incomingMessage.id] = incomingMessage
            }

            let semaphore2 = DispatchSemaphore(value: 0)
            DispatchQueue.main.async {
                self.channel.invokeMethod(
                    "shouldShowMessage",
                    arguments: [
                        "message": self.dataBridge.transformToFlutterMessage(
                            message: incomingMessage
                        )
                    ],
                    result: { (result: Any?) -> Void in
                        if let shouldShowMessage = result as? Bool {
                            shouldShow = shouldShowMessage
                        }
                        // If no Flutter handler is registered, keep the default shouldShow = true
                        semaphore2.signal()
                    }
                )
            }

            // Wait with timeout for shouldShowMessage
            if semaphore2.wait(timeout: timeout) == .timedOut {
                // Timeout occurred - Flutter handler likely not registered, use fallback
                shouldShow = true
            }
            
            return shouldShow
        }
        return true
    }

    public func urlLoaded(_ url: URL, byMessage message: Showable) {
        if let fullscreenMessage = message as? FullscreenMessage,
           let parentMessage = fullscreenMessage.parent
        {
            DispatchQueue.main.async {
                self.channel.invokeMethod(
                    "urlLoaded",
                    arguments: [
                        "url": url.absoluteString,
                        "message": self.dataBridge.transformToFlutterMessage(
                            message: parentMessage
                        ),
                    ]
                )
            }
        }
    }
}
