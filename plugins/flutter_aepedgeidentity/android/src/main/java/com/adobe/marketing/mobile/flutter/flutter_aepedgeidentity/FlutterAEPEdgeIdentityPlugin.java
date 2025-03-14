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

package com.adobe.marketing.mobile.flutter.flutter_aepedgeidentity;

import android.annotation.SuppressLint;
import android.util.Log;

import com.adobe.marketing.mobile.AdobeError;
import com.adobe.marketing.mobile.AdobeCallbackWithError;
import com.adobe.marketing.mobile.edge.identity.Identity;
import com.adobe.marketing.mobile.edge.identity.IdentityMap;
import com.adobe.marketing.mobile.edge.identity.IdentityItem;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.Map;
import java.util.List;
import java.util.ArrayList;

/** FlutterAEPEdgeIdentityPlugin */
public class FlutterAEPEdgeIdentityPlugin implements FlutterPlugin, MethodCallHandler {

  private static final String TAG = "FlutterAEPEdgeIdentityPlugin";
  private MethodChannel channel;
  

  @Override
  public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepedgeidentity");
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
        result.success(Identity.extensionVersion());
    } else if ("getExperienceCloudId".equals(call.method)) {
         handleGetExperienceCloudId(result);
    } else if ("getUrlVariables".equals(call.method)) {
         handleGetUrlVariables(result);
    } else if ("getIdentities".equals(call.method)) {
         handleGetIdentities(result);
    } else if ("updateIdentities".equals(call.method)) {
         handleUpdateIdentities(call.arguments);
         result.success(null);
    } else if ("removeIdentity".equals(call.method)) {
         Map item = call.argument("item");
         String namespace = call.argument("namespace");
         handleRemoveIdentity(item, namespace);
         result.success(null);
    }
    else {
        result.notImplemented();
    }
  }

  private void handleGetExperienceCloudId(final MethodChannel.Result result) {
    Identity.getExperienceCloudId(new AdobeCallbackWithError<String>() {
        @Override
        public void call(final String experienceCloudId) {
            AndroidUtil.runOnUIThread(() -> result.success(experienceCloudId));
        }

        @Override
        public void fail(final AdobeError adobeError) {
          final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
          AndroidUtil.runOnUIThread(() -> result.error(Integer.toString(error.getErrorCode()),"getExperienceCloudId - Failed to retrieve Experience Cloud Id",error.getErrorName()));
        } 
    });
  }

  private void handleGetUrlVariables(final MethodChannel.Result result) {
      Identity.getUrlVariables(new AdobeCallbackWithError<String>() {
          @Override
          public void call(final String urlVariables) {
              AndroidUtil.runOnUIThread(() -> result.success(urlVariables));
          }

          @Override
          public void fail(final AdobeError adobeError) {
            final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
            AndroidUtil.runOnUIThread(() -> result.error(Integer.toString(error.getErrorCode()),"getUrlVariables - failed to retrieve the URL variables",error.getErrorName()));
          }
      });
  }

  private void handleGetIdentities(final MethodChannel.Result result) {
    Identity.getIdentities(new AdobeCallbackWithError<IdentityMap>() {
        @Override
        public void call(IdentityMap map) {
            AndroidUtil.runOnUIThread(() -> {
                Map identityMap = FlutterAEPEdgeIdentityDataBridge.mapFromIdentityMap(map);
                result.success(identityMap);
            });
        }

        @Override
        public void fail(final AdobeError adobeError) {
          final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
          AndroidUtil.runOnUIThread(() -> result.error(Integer.toString(error.getErrorCode()),"getIdentity - Failed to retrieve identities",error.getErrorName()));
        }
    });
  }

 @SuppressLint("LongLogTag")
  private void handleUpdateIdentities(final Object arguments) {
    if (!(arguments instanceof Map)) {
        Log.e(TAG, "Updating Identities failed, passed IdentityMap is invalid");
        return;
    }

    Map<String,Map<String,List<Map<String,Object>>>> map = (Map) arguments;
    IdentityMap identityMap = FlutterAEPEdgeIdentityDataBridge.mapToIdentityMap(map);
    Identity.updateIdentities(identityMap);
  }

  private void handleRemoveIdentity(final Map item, final String namespace) {
    IdentityItem itemobj  = FlutterAEPEdgeIdentityDataBridge.mapToIdentityItem(item);
    Identity.removeIdentity(itemobj, namespace);
  }
}