package com.adobe.marketing.mobile.flutter.flutter_aepmessaging

import com.adobe.marketing.mobile.*
import com.adobe.marketing.mobile.messaging.Surface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FlutterAEPMessagingPlugin */
class FlutterAEPMessagingPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var messageCache = mutableMapOf<String, Message>()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_aepmessaging")
    channel.setMethodCallHandler(this)
    MobileCore.setMessagingDelegate(FlutterAEPMessagingDelegate(messageCache, channel))
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      // Messaging Methods
      "extensionVersion" -> result.success(Messaging.extensionVersion())
      "getCachedMessages" -> this.getCachedMessages(result)
      "getPropositionsForSurfaces" -> this.getPropositionsForSurfaces(call, result)
      "refreshInAppMessages" -> result.success(Messaging.refreshInAppMessages())
      "updatePropositionsForSurfaces" -> this.updatePropositionsForSurfaces(call, result)
      // Message Methods
      "clearMessage" -> this.clearMessage(call, result)
      "dismissMessage" -> this.dismissMessage(call, result)
      "handleJavascriptMessage" -> this.handleJavascriptMessage(call, result)
      "setAutoTrack" -> this.setAutoTrack(call, result)
      "showMessage" -> this.showMessage(call, result)
      "trackMessage" -> this.trackMessage(call, result)
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getCachedMessages(result: Result) {
    val cachedMessages = messageCache.values.map {
        message -> mapOf("id" to message.id, "autoTrack" to message.autoTrack)
    }.toList()
    result.success(cachedMessages)
  }

  private fun getPropositionsForSurfaces(call: MethodCall, result: Result) {
    val surfaces = call.argument<List<String>>("surfaces")?.map {
      surface ->  Surface(surface)
    }
    Messaging.getPropositionsForSurfaces(surfaces as List<Surface>, AdobeCallback {
        props -> result.success(props)
    })
  }

  private fun updatePropositionsForSurfaces(call: MethodCall, result: Result) {
    val surfaces = call.argument<List<String>>("surfaces")?.map {
      surface -> Surface(surface)
    }
    Messaging.updatePropositionsForSurfaces(surfaces as List<Surface>)
    result.success(null)
  }

  // Message Class Functions
  private fun clearMessage(call: MethodCall, result: Result) {
    val messageId = call.argument<String>("id")
    messageCache.remove(messageId)
    result.success(null)
  }

  private fun dismissMessage(call: MethodCall, result: Result) {
    val messageId = call.argument<String>("id")
    messageCache[messageId]?.dismiss(true)
    result.success(null)
  }

  private fun handleJavascriptMessage(call: MethodCall, result: Result) {
    val name = call.argument<String>("name")
    val id = call.argument<String>("id")
    messageCache[id]?.handleJavascriptMessage(name) { content ->
      if (content != null) {
        result.success(content)
      }
    }
    result.success(null)
  }

  private fun setAutoTrack(call: MethodCall, result: Result) {
    val id = call.argument<String>("id")
    val shouldAutoTrack = call.argument<Boolean>("autoTrack")
    messageCache[id]?.autoTrack = shouldAutoTrack as Boolean
    result.success(null)
  }

  private fun showMessage(call: MethodCall, result: Result) {
    val id = call.argument<String>("id")
    messageCache[id]?.show()
    result.success(null)
  }

  private fun trackMessage(call: MethodCall, result: Result) {
    val eventType = call.argument<Int>("eventType")
    val interaction = call.argument<String>("interaction")
    val messageId = call.argument<String>("id")
    val message = messageCache[messageId]
    if (message != null) {
      message.track(interaction, convertToMessagingEventType(eventType as Int))
      result.success(null)
    }
  }

  private fun convertToMessagingEventType(value: Int): MessagingEdgeEventType {
    return when (value) {
      0 -> MessagingEdgeEventType.IN_APP_DISMISS
      1 -> MessagingEdgeEventType.IN_APP_INTERACT
      2 -> MessagingEdgeEventType.IN_APP_TRIGGER
      3 -> MessagingEdgeEventType.IN_APP_DISPLAY
      4 -> MessagingEdgeEventType.PUSH_APPLICATION_OPENED
      5 -> MessagingEdgeEventType.PUSH_CUSTOM_ACTION
      else -> MessagingEdgeEventType.IN_APP_DISMISS
    }
  }
}