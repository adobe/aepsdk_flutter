package com.adobe.marketing.mobile.flutter.flutter_aepoptimize

import FlutterAEPOptimizeDataBridge
import com.adobe.marketing.mobile.AdobeCallbackWithError
import com.adobe.marketing.mobile.AdobeError
import com.adobe.marketing.mobile.optimize.DecisionScope
import com.adobe.marketing.mobile.optimize.Optimize.*
import com.adobe.marketing.mobile.optimize.Proposition
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAEPOptimizePlugin */
class FlutterAEPOptimizePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_aepoptimize")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "extensionVersion" -> result.success(extensionVersion())
            "clearCachedPropositions" -> result.success(clearCachedPropositions())
            "getPropositions" -> this.getPropositions(call, result)
            "onPropositionsUpdate" -> this.onPropositionsUpdate()
            "updatePropositions" -> this.updatePropositions(call, result)
            else -> {
                result.notImplemented()
            }
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getPropositions(call: MethodCall, result: Result) {
        val decisionScopes = (call.argument("decisionScopes") as List<Map<String, Any>>?)?.map { FlutterAEPOptimizeDataBridge.decisionScopeFromMap(it) }
        val callback = object: AdobeCallbackWithError<Map<DecisionScope, Proposition>>{
            override fun fail(adobeError: AdobeError) {
                result.error(
                    adobeError.errorCode.toString(),
                    adobeError.errorName,
                    adobeError
                )
            }

            override fun call(propositionsMap: Map<DecisionScope, Proposition>) {
                if (propositionsMap.isNotEmpty()) {
                    result.success(propositionsMap)
                }
            }
        }
        getPropositions(decisionScopes, callback)
    }

    private fun onPropositionsUpdate() {
        val callback = object: AdobeCallbackWithError<Map<DecisionScope, Proposition>>{
            override fun fail(error: AdobeError?) {
                TODO("Not yet implemented")
            }

            override fun call(propositionsMap: Map<DecisionScope, Proposition>) {
                if (propositionsMap.isNotEmpty()) {
                    channel.invokeMethod("onPropositionsUpdate", propositionsMap)
                }
            }
        }
        onPropositionsUpdate(callback)
    }

    private fun updatePropositions(call: MethodCall, result: Result){
        val arguments = call.arguments<ArrayList<Any>>()
        val decisionScopes = (arguments!![0] as List<Map<String, Any>>).map { FlutterAEPOptimizeDataBridge.decisionScopeFromMap(it) }
        val xdm = arguments[1] as Map<String, Any>?
        val data = arguments[2] as Map<String, Any>?
        result.success(updatePropositions(decisionScopes, xdm, data))
    }
}
