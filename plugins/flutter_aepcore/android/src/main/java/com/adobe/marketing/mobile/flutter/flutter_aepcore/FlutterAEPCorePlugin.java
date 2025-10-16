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

package com.adobe.marketing.mobile.flutter.flutter_aepcore;

import android.util.Log;

import com.adobe.marketing.mobile.*;

import java.util.HashMap;
import java.util.Map;
import android.app.Application;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.content.Context;

public class FlutterAEPCorePlugin implements FlutterPlugin, MethodCallHandler {
    
    private static final String TAG = "FlutterAEPCorePlugin";
    private static final String INVALID_ARGUMENT = "INVALID_ARGUMENT";
    private static final String INITIALIZATION_ERROR = "INITIALIZATION_ERROR";
    private MethodChannel channel;
    private Application application;
    private final FlutterAEPIdentityPlugin flutterAEPIdentityPlugin = new FlutterAEPIdentityPlugin();
    private final FlutterAEPLifecyclePlugin flutterAEPLifecyclePlugin = new FlutterAEPLifecyclePlugin();
    private final FlutterAEPSignalPlugin flutterAEPSignalPlugin = new FlutterAEPSignalPlugin();

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepcore");
        channel.setMethodCallHandler(this);
        Context appContext = binding.getApplicationContext();
        if (appContext instanceof Application) {
            application = (Application) appContext;
            // Set the application early to register Activity lifecycle callbacks
            // This ensures the SDK can track the current Activity for in-app messages
            // Without this, the following will happen:
            //1. Application.onCreate()
            //    ✗ No Activity lifecycle callbacks registered
            //    2. MainActivity.onCreate()
            //       ✗ SDK doesn't know about it
            //    3. MainActivity.onResume()
            //       ✗ SDK doesn't know this is current Activity
            //    4. Flutter engine initializes
            //    5. MobileCore.initialize() called from Flutter
            //       ↓ Might set Application context, but...
            //       ✗ MainActivity already went through lifecycle
            //       ✗ SDK missed the lifecycle events
            MobileCore.setApplication(application);
        }
        MobileCore.setWrapperType(WrapperType.FLUTTER);
        flutterAEPIdentityPlugin.onAttachedToEngine(binding);
        flutterAEPLifecyclePlugin.onAttachedToEngine(binding);
        flutterAEPSignalPlugin.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        application = null;
        flutterAEPIdentityPlugin.onDetachedFromEngine(binding);
        flutterAEPLifecyclePlugin.onDetachedFromEngine(binding);
        flutterAEPSignalPlugin.onDetachedFromEngine(binding);
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        final String AEPCORE_TAG = "AEPCORE";
        if ("extensionVersion".equals(call.method)) {
            result.success(MobileCore.extensionVersion());
        } else if ("initialize".equals(call.method)) {
           handleInitialize(result, call.arguments);
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
        } else if ("getSdkIdentities".equals(call.method)) {
            getSdkIdentities(result);
        } else if ("resetIdentities".equals(call.method)) {
            handleResetIdentities();
            result.success(null);
        } else if ("getPrivacyStatus".equals(call.method)) {
            getPrivacyStatus(result);
        } else if ("setAppGroup".equals(call.method)) {
            com.adobe.marketing.mobile.services.Log.debug(TAG, AEPCORE_TAG, "setAppGroup() cannot be invoked on Android");
            result.success(null);
        } else if ("setLogLevel".equals(call.method)) {
            handleSetLogLevel(call.arguments);
            result.success(null);
        } else if ("setPrivacyStatus".equals(call.method)) {
            handleSetPrivacyStatus(call.arguments);
            result.success(null);
        } else if ("updateConfiguration".equals(call.method)) {
            handleUpdateConfiguration(call.arguments);
            result.success(null);
        } else if ("clearUpdatedConfiguration".equals(call.method)) {
            handleClearUpdatedConfiguration();
            result.success(null);
        } else if ("collectPii".equals(call.method)) {
            handleCollectPii(call.arguments);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

   private void handleInitialize(Result result, Object arguments) {
       if (!(arguments instanceof Map)) {
           result.error(INVALID_ARGUMENT, "Initialize failed because arguments is not a Map", null);
           return;
       }

       if (application == null) {
           result.error(INITIALIZATION_ERROR, "Initialize failed because application is null", null);
           return;
       }

       InitOptions initOptions = FlutterAEPCoreDataBridge.initOptionsFromMap(arguments);

       if (initOptions == null) {
           result.error(INITIALIZATION_ERROR, "Initialize failed because initOptions is null", null);
           return;
       }

       MobileCore.initialize(application, initOptions, new AdobeCallback() {
           @Override
           public void call(Object o) {
               result.success(null);
           }
       });
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
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }

        Map eventMap = (Map) arguments;
        Event event = FlutterAEPCoreDataBridge.eventFromMap(eventMap);

        if (event == null) {
            Log.e(TAG, "Dispatch event failed because event is null");
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }

        MobileCore.dispatchEvent(event);
        result.success(null);
    }

    private void handleDispatchEventWithResponseCallback(final Result result, final Object arguments) {
        if (!(arguments instanceof Map)) {
            Log.e(TAG, "Dispatch event failed because arguments were invalid");
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }

        Map map = (Map) arguments;

        long timeout;
        try{
            timeout = Long.parseLong(map.get("timeout").toString());
        }catch(Exception e){
            Log.e(TAG, "Dispatch event failed because the timeout was invalid. Errors messages: " + e.getMessage());
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }

        if (!(map.get("eventData") instanceof Map)) {
            Log.e(TAG, "Dispatch event failed because the event data was invalid");
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }
        
        Map eventData = (Map) map.get("eventData");
        Event event = FlutterAEPCoreDataBridge.eventFromMap(eventData);

        if (event == null) {
            Log.e(TAG, "Dispatch event failed because event is null");
            result.error(String.valueOf(AdobeError.UNEXPECTED_ERROR.getErrorCode()), AdobeError.UNEXPECTED_ERROR.getErrorName(), null);
            return;
        }

        MobileCore.dispatchEventWithResponseCallback(event, timeout, new AdobeCallbackWithError<Event>() {
            @Override
            public void fail(AdobeError adobeError) {
                AndroidUtil.runOnUIThread(() -> result.error(String.valueOf(adobeError.getErrorCode()), adobeError.getErrorName(), null));
            }

            @Override
            public void call(Event event) {
                AndroidUtil.runOnUIThread(() -> {
                    Map eventMap = FlutterAEPCoreDataBridge.mapFromEvent(event);
                    result.success(eventMap);
                });
            }
        });
    }

    private void getSdkIdentities(final Result result) {
        MobileCore.getSdkIdentities(new AdobeCallback<String>() {
            @Override
            public void call(final String sdkIdentities) {
                AndroidUtil.runOnUIThread(() -> result.success(sdkIdentities));
            }
        });
    }

    private void getPrivacyStatus(final Result result) {
        MobileCore.getPrivacyStatus(new AdobeCallback<MobilePrivacyStatus>() {
            @Override
            public void call(final MobilePrivacyStatus mobilePrivacyStatus) {
                AndroidUtil.runOnUIThread(() -> result.success(FlutterAEPCoreDataBridge.stringFromPrivacyStatus(mobilePrivacyStatus)));
            }
        });
    }

    private void handleSetLogLevel(final Object arguments) {
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
        MobileCore.clearUpdatedConfiguration();
    }

    private void handleResetIdentities() {
        MobileCore.resetIdentities();
    }

    private void handleCollectPii(final Object arguments) {
        if (!(arguments instanceof  Map)) {
            Log.e(TAG, "CollectPii failed, arguments are invalid");
            return;
        }

        Map params = (Map) arguments;
        MobileCore.collectPii(params);
    }
}
