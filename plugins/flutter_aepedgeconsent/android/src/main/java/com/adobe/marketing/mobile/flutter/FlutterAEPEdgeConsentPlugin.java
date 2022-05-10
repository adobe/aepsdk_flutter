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

/** FlutterAEPEdgeConsentPlugin */
public class FlutterAEPEdgeConsentPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "FlutterAEPEdgeConsentPlugin";

  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepedgeconsent");
    channel.setMethodCallHandler(new FlutterAEPEdgeConsentPlugin());
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
            handleGetConsents(result);
    } else if("updateConsents".equals(call.method)) {
            handleUpdateConsents(call.arguments);
            result.success(null);
    } else {
      result.notImplemented();
    }
  }

  private void handleGetConsents(final MethodChannel.Result result) {
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

          @Override
          public void fail(final AdobeError adobeError) {
              final String errorName = adobeError != null ? adobeError.getErrorName() : AdobeError.UNEXPECTED_ERROR.getErrorName();
              result.error(Integer.toString(adobeError.getErrorCode()),"getConsents - Failed to retrieve consents",errorName);
          }
      });
  }

  private void handleUpdateConsents(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Update Consent failed because arguments were invalid, expected Map.");
            return;
        }

        Consent.update((Map) arguments);
    }
}
