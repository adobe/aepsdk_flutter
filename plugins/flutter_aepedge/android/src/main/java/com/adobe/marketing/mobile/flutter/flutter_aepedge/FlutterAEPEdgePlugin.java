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

import com.adobe.marketing.mobile.AdobeCallbackWithError;
import com.adobe.marketing.mobile.AdobeError;
import com.adobe.marketing.mobile.Edge;
import com.adobe.marketing.mobile.ExperienceEvent;
import com.adobe.marketing.mobile.EdgeCallback;
import com.adobe.marketing.mobile.EdgeEventHandle;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.VisitorID;
import com.adobe.marketing.mobile.flutter.flutter_aepcore.FlutterAEPIdentityDataBridge;

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
    channel.setMethodCallHandler(this);
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
    } else if ("getLocationHint".equals(call.method)) {
        handleGetLocationHint(result);
    } else if ("setLocationHint".equals(call.method)) {
        handleSetLocationHint(call.arguments);
        result.success(null);
    } else {
        result.notImplemented();
    }
  }

  private void handleSentEvent(final MethodChannel.Result result, final Object arguments) {
    if (!(arguments instanceof Map)) {
       Log.e(TAG, "Dispatch sendEvent failed because arguments were invalid");
       result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
       return;
    }

    Map experienceEventMap = (Map) arguments;
    ExperienceEvent experienceEvent = FlutterAEPEdgeDataBridge.eventFromMap(experienceEventMap);

    if (experienceEvent == null) {
       Log.e(TAG, "Dispatch Experience Event failed because experience event is null.");
       result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
       return;
    }

    Edge.sendEvent(experienceEvent, handles -> {
        final List<Map> arr = new ArrayList();
        if (handles != null) {
            for (EdgeEventHandle handle: handles) {
                arr.add(FlutterAEPEdgeDataBridge.mapFromEdgeEventHandle(handle));
            }
        }

        AndroidUtil.runOnUIThread(() -> result.success(arr));
    });
  }

  private void handleGetLocationHint(final MethodChannel.Result result) {
    Edge.getLocationHint(new AdobeCallbackWithError<String>() {
        @Override
        public void call(final String hint) {
            AndroidUtil.runOnUIThread(() -> result.success(hint));
        }

        @Override
        public void fail(final AdobeError adobeError) {
            final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
            AndroidUtil.runOnUIThread(() -> result.error(Integer.toString(error.getErrorCode()),"getLocationHint - Failed to retrieve location hint",error.getErrorName()));
        }
    });
  }
 
  private void handleSetLocationHint(final Object arguments) {
     if (arguments == null) {
        Edge.setLocationHint(null);
     }

     if (arguments instanceof String) {
        Edge.setLocationHint((String) arguments);
     }
   }
}