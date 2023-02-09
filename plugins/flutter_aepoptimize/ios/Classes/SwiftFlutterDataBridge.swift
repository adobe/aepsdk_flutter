import AEPOptimize;

public class SwiftFlutterDataBridge: NSObject {
  public static func decisionScopeFromDictionary(dict: Dictionary<String, Any>) {
    if (dict.get("name")) {
      return new DecisionScope(name);
    }
  }
}
