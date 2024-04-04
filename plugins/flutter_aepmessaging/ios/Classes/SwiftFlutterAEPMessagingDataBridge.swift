import AEPMessaging

public class SwiftFlutterAEPMessagingDataBridge {
    let bundleID = "mobileapp://" + Bundle.main.bundleIdentifier! + "/"

    func transformToFlutterMessage(message: Message) -> [String: Any] {
        return [
            "id": message.id, "autoTrack": message.autoTrack,
        ]   
    }

    func transformPropositionDict(dict: [Surface: [MessagingProposition]]) -> [String: [Any]]
    {
        return dict.reduce(into: [:]) { result, element in
            result[element.key.uri.replacingOccurrences(of: bundleID, with: "")] = element.value
                .map({ self.transformToProposition(proposition: $0) })
        }
    }

    func transformToProposition(proposition: MessagingProposition) -> [String: Any?] {
        return [
            "scope": proposition.scope,
            "uniqueId": proposition.uniqueId,
            "items": proposition.items.map({ item in
                [
                    "htmlContent": item.htmlContent,
                     "jsonContentArray": item.jsonContentArray,
                    "jsonContent": item.jsonContentDictionary,
                    "itemData": item.itemData as Any?,
                    "schema": item.schema.toString(),
                    "itemId": item.itemId
                ]
            }),
        ]
    }
}
