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

import android.util.Log;

import com.adobe.marketing.mobile.Message;
import com.adobe.marketing.mobile.services.MessagingDelegate;
import com.adobe.marketing.mobile.services.ui.FullscreenMessage;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterAEPMessagingDelegate implements MessagingDelegate {
  private MethodChannel channel;

  public FlutterAEPMessagingDelegate(MethodChannel channel) {
    this.channel = channel;
  }

  @Override
  public void onDismiss(FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
//      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      channel.invokeMethod("onDismiss", data);
    }
  }

  @Override
  public void onShow(FullscreenMessage fullscreenMessage) {
    final Message message = (Message)fullscreenMessage.getParent();
    if (message != null) {
      Map<String, Object> data = new HashMap<>();
      Map<String, Object> msg = new HashMap<>();
      msg.put("id", message.getId());
//      data.put("autoTrack", message.getAutoTrack());
      data.put("message", msg);
      channel.invokeMethod("onShow", data);
    }
  }

  @Override
  public boolean shouldShowMessage(FullscreenMessage fullscreenMessage) {
        final Message message = (Message)fullscreenMessage.getParent();
        final boolean[] shouldShowMessage = {true};
        if (message != null) {
          Map<String, Object> data = new HashMap<>();
          Map<String, Object> msg = new HashMap<>();
          msg.put("id", message.getId());
          //      msg.put("autoTrack", message.getAutoTrack());
          data.put("message", msg);
          channel.invokeMethod("shouldSaveMessage", data, new Result() {
            @Override
            public void success(Object o) {
              boolean shouldSaveMessage = (boolean)o;
              // if (shouldSaveMessage) {
              //   messageCache.put(message.getId(), message);
              // }
            }

            @Override
            public void error(String s, String s1, Object o) {}

            @Override
            public void notImplemented() {}
          });

          channel.invokeMethod("shouldShowMessage", data, new Result() {
            @Override
            public void success(Object o) {
              shouldShowMessage[0] = (boolean)o;
              Log.d("AEPMessaging", "success");
//              latch.countDown();
            }

            @Override
            public void error(String s, String s1, Object o) {
              Log.d(s, s1);
            }

            @Override
            public void notImplemented() {
              Log.d("AEPMessaging", "unimplemented");
            }
          });
        }
    return shouldShowMessage[0];
//        try {
////          latch.await();
//
//        } catch (final InterruptedException e) {
//          return true;
//        }
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
      channel.invokeMethod("urlLoaded", data);
    }
  }
}