package com.adobe.marketing.mobile.flutter.flutter_aepmessaging

import com.adobe.marketing.mobile.Message
import com.adobe.marketing.mobile.messaging.MessagingUtils
import com.adobe.marketing.mobile.services.ui.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch

class FlutterAEPMessagingDelegate(
  private var cache: MutableMap<String, Message>,
  private var channel: MethodChannel
) : FlutterActivity(), PresentationDelegate {
  var shouldShowMessage = true

  override fun onDismiss(presentable: Presentable<*>) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      channel.invokeMethod("onDismiss", data)
    }
  }

  override fun onShow(presentable: Presentable<*>) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      channel.invokeMethod("onShow", data)
    }
  }

  override fun onHide(presentable: Presentable<*>) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      channel.invokeMethod("onHide", data)
    }
  }

  override fun canShow(presentable: Presentable<*>): Boolean {
    if (presentable.getPresentation() !is InAppMessage) return false
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
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

  override fun onContentLoaded(presentable: Presentable<*>, presentationContent: PresentationListener.PresentationContent?) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      data["id"] = message.id
      data["autoTrack"] = message.autoTrack
      channel.invokeMethod("onContentLoaded", data)
    }
  }
}