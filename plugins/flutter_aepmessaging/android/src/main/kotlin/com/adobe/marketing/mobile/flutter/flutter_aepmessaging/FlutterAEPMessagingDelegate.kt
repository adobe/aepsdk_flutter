import com.adobe.marketing.mobile.Message
import com.adobe.marketing.mobile.services.MessagingDelegate
import com.adobe.marketing.mobile.services.ui.FullscreenMessage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch

class FlutterAEPMessagingDelegate: FlutterActivity, MessagingDelegate {
  private var channel: MethodChannel
  private var cache:  MutableMap<String, Message>
  var shouldShowMessage = true

  constructor(cache: MutableMap<String, Message>, channel: MethodChannel) {
    this.cache = cache
    this.channel = channel
  }

  override fun onDismiss(fullscreenMessage: FullscreenMessage?) {
    val message = fullscreenMessage?.parent as Message;
    if (message != null) {
      var data = HashMap<String, Any>();
      var msg = HashMap<String, Any>();
      msg.put("id", message.id);
//      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      channel.invokeMethod("onDismiss", data);
    }
  }

  override fun onShow(fullscreenMessage: FullscreenMessage?) {
    val message = fullscreenMessage?.parent as Message;
    if (message != null) {
      var data = HashMap<String, Any>();
      var msg = HashMap<String, Any>();
      msg.put("id", message.id);
//      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      channel.invokeMethod("onShow", data);
    }
  }

  override fun shouldShowMessage(fullscreenMessage: FullscreenMessage?): Boolean {
    val message = fullscreenMessage?.parent as Message;
    val latch = CountDownLatch(2)

    if (message != null) {
      var data = HashMap<String, Any>();
      var msg = HashMap<String, Any>();
      msg.put("id", message.id);
//      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);

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
    return shouldShowMessage;
  }
}