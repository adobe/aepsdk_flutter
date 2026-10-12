import AEPMessaging

public class SwiftFlutterAEPMessagingDataBridge {
    func transformToFlutterMessage(message: Message) -> [String: Any] {
        return [
            "id": message.id, "autoTrack": message.autoTrack,
        ]   
    }
}
