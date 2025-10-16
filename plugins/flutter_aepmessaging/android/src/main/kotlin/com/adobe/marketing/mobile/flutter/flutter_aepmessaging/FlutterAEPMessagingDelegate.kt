package com.adobe.marketing.mobile.flutter.flutter_aepmessaging

import android.os.Handler
import android.os.Looper
import com.adobe.marketing.mobile.Message
import com.adobe.marketing.mobile.messaging.MessagingUtils
import com.adobe.marketing.mobile.services.ui.*
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class FlutterAEPMessagingDelegate(
  private var cache: MutableMap<String, Message>,
  private var channel: MethodChannel
): PresentationDelegate {

  override fun onDismiss(presentable: Presentable<*>) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg
      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("onDismiss", data)
      }
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
      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("onShow", data)
      }
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
      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("onHide", data)
      }
    }
  }

  override fun canShow(presentable: Presentable<*>): Boolean {
    if (presentable.getPresentation() !is InAppMessage) return false
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)

    if (message != null) {
      var shouldSave = true  // Default to true for fallback
      var shouldShow = true  // Default to true for fallback
      val latch1 = CountDownLatch(1)
      val latch2 = CountDownLatch(1)

      val data = HashMap<String, Any>()
      val msg = HashMap<String, Any>()
      msg["id"] = message.id
      msg["autoTrack"] = message.autoTrack
      data["message"] = msg

      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("shouldSaveMessage", data, object : MethodChannel.Result {
          override fun success(result: Any?) {
            if (result is Boolean) {
              shouldSave = result
            }
            // If no Flutter handler is registered, result will be notImplemented
            // In that case, we keep the default shouldSave = true
            latch1.countDown()
          }

          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            latch1.countDown()
          }

          override fun notImplemented() {
            // Flutter handler not registered, use fallback
            latch1.countDown()
          }
        })
      }

      // Wait with timeout - if Flutter handler isn't available, don't wait forever
      if (!latch1.await(500, TimeUnit.MILLISECONDS)) {
        // Timeout occurred - Flutter handler likely not registered, use fallback
        shouldSave = true
      }

      // Cache the message if shouldSave is true (either from Flutter or fallback)
      if (shouldSave) {
        cache[message.id] = message
      }

      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("shouldShowMessage", data, object : MethodChannel.Result {
          override fun success(result: Any?) {
            if (result is Boolean) {
              shouldShow = result
            }
            // If no Flutter handler is registered, keep the default shouldShow = true
            latch2.countDown()
          }

          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            latch2.countDown()
          }

          override fun notImplemented() {
            // Flutter handler not registered, use fallback
            latch2.countDown()
          }
        })
      }

      // Wait with timeout for shouldShowMessage
      if (!latch2.await(500, TimeUnit.MILLISECONDS)) {
        // Timeout occurred - Flutter handler likely not registered, use fallback
        shouldShow = true
      }

      return shouldShow
    }
    return true
  }

  override fun onContentLoaded(presentable: Presentable<*>, presentationContent: PresentationListener.PresentationContent?) {
    if (presentable.getPresentation() !is InAppMessage) return
    val message = MessagingUtils.getMessageForPresentable(presentable as Presentable<InAppMessage>)
    if (message != null) {
      val data = HashMap<String, Any>()
      data["id"] = message.id
      data["autoTrack"] = message.autoTrack
      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("onContentLoaded", data)
      }
    }
  }
}