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
import com.adobe.marketing.mobile.Event;
import com.adobe.marketing.mobile.ExtensionError;
import com.adobe.marketing.mobile.ExtensionErrorCallback;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.MobilePrivacyStatus;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterAEPCorePlugin implements FlutterPlugin, MethodCallHandler {

    private final String TAG = "FlutterAEPCorePlugin";
    private MethodChannel channel;
    private final FlutterAEPIdentityPlugin flutterAEPIdentityPlugin = new FlutterAEPIdentityPlugin();
    private final FlutterAEPLifecyclePlugin flutterAEPLifecyclePlugin = new FlutterAEPLifecyclePlugin();
    private final FlutterAEPSignalPlugin flutterAEPSignalPlugin = new FlutterAEPSignalPlugin();

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepcore");
        channel.setMethodCallHandler(new FlutterAEPCorePlugin());
        flutterAEPIdentityPlugin.onAttachedToEngine(binding);
        flutterAEPLifecyclePlugin.onAttachedToEngine(binding);
        flutterAEPSignalPlugin.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        flutterAEPIdentityPlugin.onDetachedFromEngine(binding);
        flutterAEPLifecyclePlugin.onDetachedFromEngine(binding);
        flutterAEPSignalPlugin.onDetachedFromEngine(binding);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        final String AEPCORE_TAG = "AEPCORE";
        if ("extensionVersion".equals(call.method)) {
            result.success(MobileCore.extensionVersion());
        } else if ("track".equals(call.method)) {
            handleTrackCall(call.arguments);
            result.success(null);
        } else if ("setAdvertisingIdentifier".equals(call.method)) {
            handleSetAdvertisingIdentifier(call.arguments);
            result.success(null);
        } else if ("dispatchEvent".equals(call.method)) {
            handleDispatchEvent(result, call.arguments);
        } else if ("dispatchEventWithResponseCallback".equals(call.method)) {
            handleDispatchEventWithResponseCallback(result, call.arguments);
        } else if ("dispatchResponseEvent".equals(call.method)) {
            handleDispatchResponseEvent(result, call.arguments);
        } else if ("downloadRules".equals(call.method)) {
            MobileCore.log(LoggingMode.DEBUG, AEPCORE_TAG, "downloadRules() cannot be invoked on Android");
            result.success(null);
        } else if ("getSdkIdentities".equals(call.method)) {
            getSdkIdentities(result);
        } else if ("getPrivacyStatus".equals(call.method)) {
            getPrivacyStatus(result);
        } else if ("setAppGroup".equals(call.method)) {
            MobileCore.log(LoggingMode.DEBUG, AEPCORE_TAG, "setAppGroup() cannot be invoked on Android");
            result.success(null);
        } else if ("setLogLevel".equals(call.method)) {
            setLogLevel(call.arguments);
            result.success(null);
        } else if ("setPrivacyStatus".equals(call.method)) {
            handleSetPrivacyStatus(call.arguments);
            result.success(null);
        } else if ("updateConfiguration".equals(call.method)) {
            handleUpdateConfiguration(call.arguments);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void handleTrackCall(Object arguments) {
        if (!(arguments instanceof Map) || !((Map) arguments).containsKey("type") || !((Map) arguments).containsKey("name")) {
            Log.e(TAG, "Track action failed because arguments were invalid");
            return;
        }

        Map<String, Object> params = (Map<String, Object>) arguments;
        if (!(params.get("type") instanceof String)) {
            Log.e(TAG, "Track action failed because type is invalid");
            return;
        }
        if (!(params.get("name") instanceof String)) {
            Log.e(TAG, "Track action failed because name is invalid");
            return;
        }

        String type = (String) params.get("type");
        String name = (String) params.get("name");

        Map data = new HashMap();
        if (params.containsKey("data") && params.get("data") instanceof Map) {
            data = (Map) params.get("data");
        }

        if ("state".equals(type)) {
            MobileCore.trackState(name, data);
        } else if ("action".equals(type)) {
            MobileCore.trackAction(name, data);
        }
    }

    private void handleSetAdvertisingIdentifier(final Object arguments) {
        if (arguments == null) {
            MobileCore.setAdvertisingIdentifier(null);
        }

        if (arguments instanceof String) {
            MobileCore.setAdvertisingIdentifier((String) arguments);
        }
    }

    private void handleDispatchEvent(final Result result, final Object arguments) {
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

        MobileCore.dispatchEvent(event, new ExtensionErrorCallback<ExtensionError>() {
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

    private void handleDispatchEventWithResponseCallback(final Result result, final Object arguments) {
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

    private void handleDispatchResponseEvent(final Result result, final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Dispatch event failed because arguments were invalid");
            return;
        }

        Map eventMap = (Map) arguments;
        Map responseEventMap = (Map) eventMap.get("responseEvent");
        Map requestEventMap = (Map) eventMap.get("requestEvent");
        Event responseEvent = FlutterAEPCoreDataBridge.eventFromMap(responseEventMap);
        Event requestEvent = FlutterAEPCoreDataBridge.eventFromMap(requestEventMap);

        if (responseEvent == null || requestEvent == null) {
            Log.e(TAG, "Dispatch response event failed because responseEvent or requestEvent is null");
            return;
        }

        MobileCore.dispatchResponseEvent(responseEvent, requestEvent, new ExtensionErrorCallback<ExtensionError>() {
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
                    AndroidUtil.runOnUIThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(null);
                        }
                    });
                }
            }
        });
    }

    private void getSdkIdentities(final Result result) {
        MobileCore.getSdkIdentities(new AdobeCallback<String>() {
            @Override
            public void call(final String sdkIdentities) {
                AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(sdkIdentities);
                    }
                });
            }
        });
    }

    private void getPrivacyStatus(final Result result) {
        MobileCore.getPrivacyStatus(new AdobeCallback<MobilePrivacyStatus>() {
            @Override
            public void call(final MobilePrivacyStatus mobilePrivacyStatus) {
                AndroidUtil.runOnUIThread(new Runnable() {
                    @Override
                    public void run() {
                        result.success(FlutterAEPCoreDataBridge.stringFromPrivacyStatus(mobilePrivacyStatus));
                    }
                });
            }
        });
    }

    private void setLogLevel(final Object arguments) {
        if (!(arguments instanceof String)) {
            Log.e(TAG, "Setting log level failed, arguments are invalid");
            return;
        }

        String mode = (String) arguments;
        LoggingMode loggingMode = FlutterAEPCoreDataBridge.loggingModeFromString(mode);
        MobileCore.setLogLevel(loggingMode);
    }

    private void handleSetPrivacyStatus(final Object arguments) {
        if (!(arguments instanceof String)) {
            Log.e(TAG, "Setting privacy failed, arguments are invalid");
            return;
        }

        String privacyStatus = (String) arguments;
        MobilePrivacyStatus mobilePrivacyStatus = FlutterAEPCoreDataBridge.privacyStatusFromString(privacyStatus);
        MobileCore.setPrivacyStatus(mobilePrivacyStatus);
    }

    private void handleUpdateConfiguration(final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Updating the configuration failed, arguments are invalid");
            return;
        }

        Map params = (Map) arguments;
        MobileCore.updateConfiguration(params);
    }

    private void handleClearUpdatedConfiguration() {

    }
}
