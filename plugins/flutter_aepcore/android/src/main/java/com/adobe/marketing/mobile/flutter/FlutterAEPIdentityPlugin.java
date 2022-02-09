/*
Copyright 2020 Adobe. All rights reserved.
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

import com.adobe.marketing.mobile.AdobeCallback;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.VisitorID;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterAEPIdentityPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {

    private String TAG = "FlutterAEPIdentityPlugin";

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepidentity");
        channel.setMethodCallHandler(new FlutterAEPIdentityPlugin());
    }

    @Override
    public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if ("extensionVersion".equals(call.method)) {
            result.success(Identity.extensionVersion());
        } else if("appendToUrl".equals(call.method)) {
            handleAppendToUrl(result, call.arguments);
        } else if("getIdentifiers".equals(call.method)) {
            handleGetIdentifiers(result);
        } else if("getExperienceCloudId".equals(call.method)) {
            handleGetExperienceCloudId(result);
        } else if("syncIdentifier".equals(call.method)) {
            handleSyncIdentifier(call.arguments);
            result.success(null);
        } else if("syncIdentifiers".equals(call.method)) {
            handleSyncIdentifiers(call.arguments);
            result.success(null);
        } else if("syncIdentifiersWithAuthState".equals(call.method)) {
            handleSyncIdentifiersWithAuthState(call.arguments);
        } else if("urlVariables".equals(call.method)) {
            handleUrlVariables(result);
        } else {
            result.notImplemented();
        }
    }

    private void handleAppendToUrl(final MethodChannel.Result result, final Object arguments) {
        if (arguments instanceof String) {
            Identity.appendVisitorInfoForURL((String) arguments, new AdobeCallback<String>() {
                @Override
                public void call(final String url) {
                    AndroidUtil.runOnUIThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(url);
                        }
                    });
                }
            });
        } else {
            Log.e(TAG, "Failed to handle append to url, url is not string");
        }
    }

    private void handleGetIdentifiers(final MethodChannel.Result result) {
        Identity.getIdentifiers(new AdobeCallback<List<VisitorID>>() {

            @Override
            public void call(List<VisitorID> visitorIDS) {
                final List<Map> ids = new ArrayList<>();
                for (VisitorID visitor: visitorIDS) {
                    ids.add(FlutterAEPIdentityDataBridge.mapFromVisitorIdentifier(visitor));
                }
                AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(ids);
                    }
                });
            }
        });
    }

    private void handleGetExperienceCloudId(final MethodChannel.Result result) {
        Identity.getExperienceCloudId(new AdobeCallback<String>() {
            @Override
            public void call(final String couldId) {
                AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(couldId);
                    }
                });
            }
        });
    }

    private void handleSyncIdentifier(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Sync identifier failed because arguments were invalid");
            return;
        }

        Map<String, Object> params = (Map<String, Object>) arguments;
        if (!(params.get("identifierType") instanceof String) || !(params.get("identifier") instanceof String) || !(params.get("authState") instanceof String)) {
            Log.e(TAG, "Sync identifier failed because arguments were invalid");
        }

        String identifierType = (String) params.get("identifierType");
        String identifier = (String) params.get("identifier");
        VisitorID.AuthenticationState authenticationState = FlutterAEPIdentityDataBridge.authenticationStateFromString((String) params.get("authState"));

        Identity.syncIdentifier(identifierType, identifier, authenticationState);
    }

    private void handleSyncIdentifiers(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Sync identifiers failed because arguments were invalid");
            return;
        }

        Identity.syncIdentifiers((Map) arguments);
    }

    private void handleSyncIdentifiersWithAuthState(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Sync identifiers failed because arguments were invalid");
            return;
        }

        Map params = (Map) arguments;
        if (!(params.get("identifiers") instanceof Map) && !(params.get("authState") instanceof String)) {
            Log.e(TAG, "Sync identifier failed because arguments were invalid");
        }
        Map identifiers = (Map) params.get("identifiers");
        VisitorID.AuthenticationState authenticationState = FlutterAEPIdentityDataBridge.authenticationStateFromString((String) params.get("authState"));
        Identity.syncIdentifiers(identifiers, authenticationState);
    }

    private void handleUrlVariables(final MethodChannel.Result result) {
        Identity.getUrlVariables(new AdobeCallback<String>() {
            @Override
            public void call(final String urlVariables) {
                AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(urlVariables);
                    }
                });
            }
        });
    }
}
