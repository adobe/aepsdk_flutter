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
        case "handleJavascriptMessage":
            return result(handleJavascriptMessage(arguments: call.arguments))
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

    private func handleJavascriptMessage(arguments: Any?) -> Any? {
        if let args = arguments as? [String: Any],
            let id = args["id"] as? String,
            let name = args["name"] as? String
        {
            let msg = messageCache[id]
            if msg != nil {
                return nil
                //          return msg!.handleJavascriptMessage(name)
            }
            return FlutterError.init(
                code: "CACHE MISS",
                message: "Message has not been cached",
                details: nil
            )
        }
        return FlutterError.init(
            code: "BAD ARGUMENTS",
            message: nil,
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
                ?? MessagingEdgeEventType.inappDismiss
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
        public func onDismiss(message: Showable) {
            if let fullscreenMessage = message as? FullscreenMessage,
                let parentMessage = fullscreenMessage.parent as? Message
            {
                channel.invokeMethod(
                    "onDismiss",
                    arguments: [
                        "message": dataBridge.transformToFlutterMessage(
                            message: parentMessage
                        )
                    ]
                )
            }
        }
    }

    public func onShow(message: Showable) {
        public func onDismiss(message: Showable) {
            if let fullscreenMessage = message as? FullscreenMessage,
                let parentMessage = fullscreenMessage.parent as? Message
            {
                channel.invokeMethod(
                    "onShow",
                    arguments: [
                        "message": dataBridge.transformToFlutterMessage(
                            message: parentMessage
                        )
                    ]
                )
            }
        }
    }

    public func shouldShowMessage(message: Showable) -> Bool {
        if let fullscreenMessage = message as? FullscreenMessage,
            let incomingMessage = fullscreenMessage.parent as? Message
        {
            var shouldShow = false
            let semaphore = DispatchSemaphore(value: 0)
            channel.invokeMethod(
                "shouldSaveMessage",
                arguments: [
                    "message": dataBridge.transformToFlutterMessage(
                        message: incomingMessage
                    )
                ],
                result: { (result: Any?) -> Void in
                    if let shouldSaveMessage = result as? Bool {
                        if shouldSaveMessage {
                            self.messageCache[incomingMessage.id] = incomingMessage
                        }
                    }
                    semaphore.signal()
                }
            )

            semaphore.wait()

            channel.invokeMethod(
                "shouldShowMessage",
                arguments: [
                    "message": dataBridge.transformToFlutterMessage(
                        message: incomingMessage
                    )
                ],
                result: { (result: Any?) -> Void in
                    if let shouldShowMessage = result as? Bool {
                        shouldShow = shouldShowMessage
                    }
                    semaphore.signal()
                }
            )

            semaphore.wait()
            return shouldShow
        }
    }

    public func urlLoaded(_ url: URL, byMessage message: Showable) {
        if let fullscreenMessage = message as? FullscreenMessage,
            let parentMessage = fullscreenMessage.parent as? Message
        {
            channel.invokeMethod(
                "urlLoaded",
                arguments: [
                    "url": url.absoluteString,
                    "message": dataBridge.transformToFlutterMessage(
                        message:
                    ),
                ]
            )
        }
    }
}
