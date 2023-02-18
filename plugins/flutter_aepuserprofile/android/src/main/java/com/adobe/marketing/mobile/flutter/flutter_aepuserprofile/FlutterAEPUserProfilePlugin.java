/*
Copyright 2023 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

package com.adobe.marketing.mobile.flutter.flutter_aepuserprofile;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.adobe.marketing.mobile.AdobeCallbackWithError;
import com.adobe.marketing.mobile.AdobeError;
import com.adobe.marketing.mobile.UserProfile;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/**
 * FlutterAEPUserProfilePlugin
 */
public class FlutterAEPUserProfilePlugin implements FlutterPlugin, MethodCallHandler {

  private final String TAG = "FlutterAEPUserProfilePlugin";
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepuserprofile");
    channel.setMethodCallHandler(new FlutterAEPUserProfilePlugin());
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
      result.success(UserProfile.extensionVersion());
    } else if ("getUserAttributes".equals((call.method))) {
      handleGetUserAttributes(call.arguments, result);
    } else if ("removeUserAttributes".equals(call.method)) {
      handleRemoveUserAttributes(call.arguments);
      result.success(null);
    } else if ("updateUserAttributes".equals((call.method))) {
      handleUpdateUserAttributes(call.arguments);
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  @SuppressLint("LongLogTag")
  private void handleGetUserAttributes(Object arguments, final Result result) {
    if (!(arguments instanceof List)) {
      Log.e(TAG, "Get user attributes failed because arguments were invalid");
      return;
    }

    List<String> attributes = (List) arguments;
    UserProfile.getUserAttributes(attributes, new AdobeCallbackWithError<Map<String, Object>>() {
      @Override
      public void fail(AdobeError adobeError) {
        runOnUIThread(() -> result.error(String.valueOf(adobeError.getErrorCode()), adobeError.getErrorName(), null));
      }

      @Override
      public void call(Map<String, Object> retrievedAttributes) {
        if (retrievedAttributes == null) {
          fail(AdobeError.UNEXPECTED_ERROR);
        } else {
          JSONObject obj = new JSONObject(retrievedAttributes);
          runOnUIThread(() -> result.success(obj.toString()));
        }
      }
    });
  }

  @SuppressLint("LongLogTag")
  private void handleRemoveUserAttributes(Object arguments) {
    if (!(arguments instanceof List)) {
      Log.e(TAG, "Removing user attributes failed because arguments were invalid");
      return;
    }
    List<String> attributes = (List) arguments;
    UserProfile.removeUserAttributes(attributes);
  }

  @SuppressLint("LongLogTag")
  private void handleUpdateUserAttributes(Object arguments) {
    if (!(arguments instanceof Map)) {
      Log.e(TAG, "Update User Attributes failed, arguments are invalid");
      return;
    }

    Map params = (Map) arguments;
    UserProfile.updateUserAttributes(params);
  }

  void runOnUIThread(Runnable runnable) {
    new Handler(Looper.getMainLooper()).post(runnable);
  }
}