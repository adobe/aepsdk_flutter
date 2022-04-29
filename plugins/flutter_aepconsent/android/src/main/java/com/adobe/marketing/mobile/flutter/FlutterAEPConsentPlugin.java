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

import com.adobe.marketing.mobile.edge.consent.Consent;
import com.adobe.marketing.mobile.AdobeError;
import com.adobe.marketing.mobile.AdobeCallbackWithError;

import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterAEPConsentPlugin */
public class FlutterAEPConsentPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "FlutterAEPConsentPlugin";

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepconsent");
    channel.setMethodCallHandler(new FlutterAEPConsentPlugin());
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
      result.success(Consent.extensionVersion());
    } else if("getConsents".equals(call.method)) {
            handleGetConsent(result);
    } else if("updateConsents".equals(call.method)) {
            handleUpdateConsent(call.arguments);
            result.success(null);
    } else {
      result.notImplemented();
    }
  }

  private void handleGetConsent(final MethodChannel.Result result) {
      Consent.getConsents(new AdobeCallbackWithError<Map<String, Object>>() {
          @Override
          public void call(final Map<String, Object> consents) {
              AndroidUtil.runOnUIThread(new Runnable() {
                  @Override
                  public void run() {
                      result.success(consents);
                  }
              });
          }
      });
  }

  private void handleUpdateConsent(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Update Consent failed because arguments were invalid");
            return;
        }

        Consent.update((Map) arguments);
    }
}
