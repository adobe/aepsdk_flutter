/*
Copyright 2022 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

package com.adobe.marketing.mobile.flutter.flutter_aepedge;

import android.util.Log;

import com.adobe.marketing.mobile.Edge;
import com.adobe.marketing.mobile.ExperienceEvent;
import com.adobe.marketing.mobile.EdgeCallback;
import com.adobe.marketing.mobile.EdgeEventHandle;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.Map;
import java.util.List;
import java.util.ArrayList;

/** FlutterAEPEdgePlugin */
public class FlutterAEPEdgePlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "FlutterAEPEdgePlugin";

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepedge");
    channel.setMethodCallHandler(new FlutterAEPEdgePlugin());
  }

  @Override
  public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if ("extensionVersion".equals(call.method)) {
      result.success(Edge.extensionVersion());
    } else if ("sendEvent".equals(call.method)) {
      handleSentEvent(result, call.arguments);
    } else {
      result.notImplemented();
    }
  }

  private void handleSentEvent(final MethodChannel.Result result, final Object arguments) {
     if (!(arguments instanceof Map)) {
       Log.e(TAG, "Dispatch sendEvent failed because arguments were invalid");
       return;
     }

     Map experienceEventMap = (Map) arguments;
     ExperienceEvent experienceEvent = FlutterAEPEdgeDataBridge.eventFromMap(experienceEventMap);

      if (experienceEvent == null) {
      Log.e(TAG, "Dispatch Experience Event failed because event is null");
      result.error("Dispatch Experence Event failed", "ExperienceEvent is null", "Expect a valid Expereince event");
      return;
    }

     Edge.sendEvent(experienceEvent, new EdgeCallback() {
     @Override
     public void onComplete(final List<EdgeEventHandle> handles) {

        final List<Map> arr = new ArrayList<>();
        if (handles == null) {
          AndroidUtil.runOnUIThread(new Runnable() {
            @Override
            public void run() {
              result.success(arr);
              return;
            }
          });
        }
       

        for (EdgeEventHandle handle: handles) {
          arr.add(FlutterAEPEdgeDataBridge.mapFromEdgeEventHandle(handle));
        }
        AndroidUtil.runOnUIThread(new Runnable() {
          @Override
          public void run() {
           result.success(arr);
          }
        });
      }
    });
  }
}