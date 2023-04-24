/*
Copyright 2023 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance with the License. You
may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
REPRESENTATIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/
package com.adobe.marketing.mobile.flutter.flutter_aepmessaging;

import androidx.annotation.NonNull;
import com.adobe.marketing.mobile.AdobeCallback;
import com.adobe.marketing.mobile.Message;
import com.adobe.marketing.mobile.Messaging;
import com.adobe.marketing.mobile.MessagingEdgeEventType;
import com.adobe.marketing.mobile.services.MessagingDelegate;
import com.adobe.marketing.mobile.services.ui.FullscreenMessage;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/** FlutterAEPMessagingPlugin */
public class FlutterAEPMessagingPlugin
    implements FlutterPlugin, MessagingDelegate, MethodCallHandler {
  private final String TAG = "FlutterAEPMessagingPlugin";
  private MethodChannel channel;
  private final Map<String, Message> messageCache = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel =
        new MethodChannel(binding.getBinaryMessenger(), "flutter_aepmessaging");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void
  onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
    // Messaging Methods
    case "extensionVersion":
      result.success(Messaging.extensionVersion());
    case "getCachedMessages":
      this.getCachedMessages(call, result);
    case "refreshInAppMessages":
      Messaging.refreshInAppMessages();
      result.success(null);
    // Message Methods
    case "clearMessage":
      this.clearMessage(call, result);
    case "dismissMessage":
      this.dismissMessage(call, result);
    case "handleJavascriptMessage":
      this.handleJavascriptMessage(call, result);
    case "setAutoTrack":
      this.setAutoTrack(call, result);
    case "showMessage":
      this.showMessage(call, result);
    case "trackMessage":
      this.trackMessage(call, result);
    default:
      result.notImplemented();
    }
  }

  private void getCachedMessages(MethodCall call, @NonNull Result result) {
    List<Map<String, Object>> messages = new ArrayList<>();
    Iterator<Message> iterator = messageCache.values().iterator();
    while (iterator.hasNext()) {
      Message message = iterator.next();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
      //      data.put("autoTrack", message.getAutoTrack());
      messages.add(msg);
    }
    result.success(messages);
  }

  // Message Methods
  private void clearMessage(MethodCall call, @NonNull Result result) {
    String id = call.argument("id");
    if (id != null) {
      messageCache.remove(id);
      result.success(null);
    }
    result.error("BAD ARGUMENTS", "No Message ID was supplied to clearMessage",
                 null);
  }

  private void dismissMessage(MethodCall call, @NonNull Result result) {
    String id = call.argument("id");
    Boolean suppressAutoTrack = call.argument("suppressAutoTrack");
    Message msg = messageCache.get(id);
    if (msg != null) {
      msg.dismiss(suppressAutoTrack ? suppressAutoTrack : false);
      result.success(null);
    }
    result.error("CACHE MISS",
                 "Cannot dismiss message as it has not been cached", null);
  }

  private void handleJavascriptMessage(MethodCall call,
                                       @NonNull Result result) {
    String id = call.argument("id");
    String name = call.argument("name");
    Message msg = messageCache.get(id);
    if (msg != null) {
      msg.handleJavascriptMessage(name, new AdobeCallback<String>() {
        @Override()
        public void call(String content) {
          result.success(content);
        }
      });
    }
    result.error(
        "CACHE MISS",
        "Cannot call handleJavascriptMessage as it has not been cached", null);
  }

  private void setAutoTrack(MethodCall call, @NonNull Result result) {
    String id = call.argument("id");
    Boolean autoTrack = call.argument("autoTrack");
    Message msg = messageCache.get(id);
    if (msg != null) {
      msg.setAutoTrack(autoTrack);
    }
    result.error("CACHE MISS",
                 "Cannot setAutoTrack as message has not been cached", null);
  }

  private void showMessage(MethodCall call, @NonNull Result result) {
    String id = call.argument("id");
    Message msg = messageCache.get(id);
    if (msg != null) {
      msg.show();
    }
    result.error("CACHE MISS", "Cannot show a message that has not been cached",
                 null);
  }

  private void trackMessage(MethodCall call, @NonNull Result result) {
    String id = call.argument("id");
    String interaction = call.argument("interaction");
    MessagingEdgeEventType eventType = call.argument("eventType");
    Message msg = messageCache.get(id);
    if (msg != null) {
      msg.track(interaction, eventType);
    }
    result.error("CACHE MISS",
                 "Cannot track a message that has not been cached", null);
  }

  // Messaging Delegate
  @Override
  public void onDismiss(final FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
      //      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      this.channel.invokeMethod("onDismiss", data);
    }
  }

  @Override
  public void onShow(final FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
      //      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      this.channel.invokeMethod("onShow", data);
    }
  }

  @Override
  public boolean shouldShowMessage(final FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    final boolean[] shouldShowMessage = {false};
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
      //      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      this.channel.invokeMethod("onShouldSaveMessage", data, new Result() {
        @Override
        public void success(Object o) {
          boolean shouldSaveMessage = (boolean)o;
          if (shouldSaveMessage) {
            messageCache.put(message.getId(), message);
          }
        }

        @Override
        public void error(String s, String s1, Object o) {}

        @Override
        public void notImplemented() {}
      });

      this.channel.invokeMethod("onShouldShowMessage", data, new Result() {
        @Override
        public void success(Object o) {
          shouldShowMessage[0] = (boolean)o;
        }

        @Override
        public void error(String s, String s1, Object o) {}

        @Override
        public void notImplemented() {}
      });
    }
    return shouldShowMessage[0];
  }

  @Override
  public void urlLoaded(String url, FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
      //      msg.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      data.put("url", url);
      this.channel.invokeMethod("onUrlLoaded", data);
    }
  }
}