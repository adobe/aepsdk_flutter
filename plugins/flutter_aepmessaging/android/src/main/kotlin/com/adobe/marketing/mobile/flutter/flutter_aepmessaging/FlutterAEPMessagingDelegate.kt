package com.adobe.marketing.mobile.flutter.flutter_aepmessaging

import com.adobe.marketing.mobile.Message
import com.adobe.marketing.mobile.services.MessagingDelegate
import com.adobe.marketing.mobile.services.ui.FullscreenMessage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch

class FlutterAEPMessagingDelegate(
  private var cache: MutableMap<String, Message>,
  private var channel: MethodChannel
) : FlutterActivity(), MessagingDelegate {
  var shouldShowMessage = true

  override fun onDismiss(fullscreenMessage: FullscreenMessage?) {
    val message = fullscreenMessage?.parent as Message
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      channel.invokeMethod("onDismiss", data)
    }
  }

  override fun onShow(fullscreenMessage: FullscreenMessage?) {
    val message = fullscreenMessage?.parent as Message
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      channel.invokeMethod("onShow", data)
    }
  }

  override fun shouldShowMessage(fullscreenMessage: FullscreenMessage?): Boolean {
    val message = fullscreenMessage?.parent as Message
    val latch = CountDownLatch(2)

    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg

      runOnUiThread {
        channel.invokeMethod("shouldSaveMessage", data, object : MethodChannel.Result {
          override fun success(result: Any?) {
            if (result as Boolean) {
              cache[message.id] = message
              latch.countDown()
            }
          }

          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}

          override fun notImplemented() {}
        })

        channel.invokeMethod("shouldShowMessage", data, object : MethodChannel.Result {
          override fun success(result: Any?) {
            shouldShowMessage = result as Boolean
            latch.countDown()
          }

          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}

          override fun notImplemented() {}
        })
      }
    }

    latch.await()
    return shouldShowMessage
  }

  override fun urlLoaded(url: String, fullscreenMessage: FullscreenMessage) {
    val message = fullscreenMessage.parent as Message
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      data["url"] = url
      channel.invokeMethod("urlLoaded", data)
    }
  }
}