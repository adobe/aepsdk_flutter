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

package com.adobe.marketing.mobile.flutter;

import android.util.Log;

import com.adobe.marketing.mobile.Edge;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

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

  private void handleSentEvent(final Result result, final Object arguments) {
    if (!(arguments instanceof Map)) {
      Log.e(TAG, "Dispatch event failed because arguments were invalid");
      return;
    }

    Map eventMap = (Map) arguments;
    Event event = FlutterAEPCoreDataBridge.eventFromMap(eventMap);

    if (event == null) {
      Log.e(TAG, "Dispatch event failed because event is null");
      return;
    }

    MobileCore.dispatchEventWithResponseCallback(event,
            new AdobeCallback<Event>() {
              @Override
              public void call(Event event) {
                Map eventMap = FlutterAEPCoreDataBridge.mapFromEvent(event);
                result.success(eventMap);
              }
            }, new ExtensionErrorCallback<ExtensionError>() {
              @Override
              public void error(final ExtensionError extensionError) {
                if (extensionError != null) {
                  AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                      result.error(String.valueOf(extensionError.getErrorCode()), extensionError.getErrorName(), null);
                    }
                  });
                } else {
                  result.success(null);
                }
              }
            });
  }
}
