import AEPCore;
import AEPOptimize;
import Flutter
import UIKit


public class SwiftFlutterAEPOptimizePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_aepoptimize", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterAEPOptimizePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "extensionVersion":
            return result(Optimize.extensionVersion);
        case "clearCachedPropositions":
            Optimize.clearCachedPropositions();
            return result(nil);
        case "getPropositions":
            print(type(of: (call.arguments as? Dictionary<String, Any>)?["decisionScopes"]))
            if let args = call.arguments as? Dictionary<String, Any>,
               let scopes = args["decisionScopes"] as? Array<Dictionary<String, Any>> {
                let decisionScopes = scopes.map { self.decisionScopeFromDictionary(dict: $0) }
                Optimize.getPropositions(for: decisionScopes) {
                    propositionsDict, error in
                    if let error = error {
                        result(error);
                    }
                    
                    if let propositionsDict = propositionsDict {
                        result(propositionsDict);
                    }
                }
            };
            //      case "onPropositionsUpdate":
            //        return result(Optimize.onPropositionsUpdate(call.arguments));
        case "updatePropositions":
            if let args = call.arguments as? Dictionary<String, Any>,
               let decisionScopes = args["decisionScopes"] as? [DecisionScope],
               let xdm = args["xdm"] as? [String: Any]?,
               let data = args["data"] as? [String: Any]? {
                result(Optimize.updatePropositions(for: decisionScopes, withXdm: xdm, andData: data));
            }
        default:
            return result(FlutterMethodNotImplemented);
        }
    }
    
    public func decisionScopeFromDictionary(dict: Dictionary<String, Any>) -> DecisionScope {
        if let name = dict["name"] as! String? {
            return DecisionScope(name: name);
        }
        return DecisionScope(name: dict["name"] as! String)
    };
}
