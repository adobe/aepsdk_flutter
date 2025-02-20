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

import com.adobe.marketing.mobile.Event;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobilePrivacyStatus;
import com.adobe.marketing.mobile.InitOptions;

import java.util.HashMap;
import java.util.Map;

public class FlutterAEPCoreDataBridge {

    // @{link LoggingMode}
    public final static String AEP_LOG_LEVEL_ERROR = "AEP_LOG_LEVEL_ERROR";
    public final static String AEP_LOG_LEVEL_WARNING = "AEP_LOG_LEVEL_WARNING";
    public final static String AEP_LOG_LEVEL_DEBUG = "AEP_LOG_LEVEL_DEBUG";
    public final static String AEP_LOG_LEVEL_VERBOSE = "AEP_LOG_LEVEL_VERBOSE";

    // @{link @VisitorID.AuthenticationState}
    public final static String AEP_PRIVACY_STATUS_OPT_IN = "AEP_PRIVACY_STATUS_OPT_IN";
    public final static String AEP_PRIVACY_STATUS_OPT_OUT = "AEP_PRIVACY_STATUS_OPT_OUT";
    public final static String AEP_PRIVACY_STATUS_UNKNOWN = "AEP_PRIVACY_STATUS_UNKNOWN";

    // Event Object Keys
    public final static String EVENT_NAME_KEY = "eventName";
    public final static String EVENT_TYPE_KEY = "eventType";
    public final static String EVENT_SOURCE_KEY = "eventSource";
    public final static String EVENT_DATA_KEY = "eventData";

    private final static String APPID_KEY = "appId";
    private final static String LIFECYCLE_AUTOMATIC_TRACKING_KEY = "lifecycleAutomaticTrackingEnabled";
    private static final String LIFECYCLE_ADDITIONAL_CONTEXTDATA_KEY = "lifecycleAdditionalContextData";

    /**
     * Converts a {@link Map} into an {@link Event}
     *
     * @param map
     * @return An {@link Event}
     */
    static Event eventFromMap(final Map map) {
        Event event = new Event.Builder(
                getNullableString(map, EVENT_NAME_KEY),
                getNullableString(map, EVENT_TYPE_KEY),
                getNullableString(map, EVENT_SOURCE_KEY))
                .setEventData(getNullableMap(map, EVENT_DATA_KEY))
                .build();
        return event;
    }

    static Map mapFromEvent(final Event event) {
        Map<String, Object> map = new HashMap<>();
        map.put(EVENT_NAME_KEY, event.getName());
        map.put(EVENT_TYPE_KEY, event.getType());
        map.put(EVENT_SOURCE_KEY, event.getSource());
        map.put(EVENT_DATA_KEY, event.getEventData());
        return map;
    }

    /**
     * Takes in a {@link String} and returns the associated enum {error, warning, debug, verbose}
     *
     * @param logModeString
     * @return The @{link LoggingMode} associated with logModeString
     */
    static LoggingMode loggingModeFromString(final String logModeString) {
        if (logModeString.equals(AEP_LOG_LEVEL_ERROR)) {
            return LoggingMode.ERROR;
        } else if (logModeString.equals(AEP_LOG_LEVEL_WARNING)) {
            return LoggingMode.WARNING;
        } else if (logModeString.equals(AEP_LOG_LEVEL_DEBUG)) {
            return LoggingMode.DEBUG;
        } else if (logModeString.equals(AEP_LOG_LEVEL_VERBOSE)) {
            return LoggingMode.VERBOSE;
        }

        return LoggingMode.DEBUG;
    }

    public static String stringFromLoggingMode(final LoggingMode logMode) {
        switch (logMode) {
            case ERROR:
                return AEP_LOG_LEVEL_ERROR;
            case WARNING:
                return AEP_LOG_LEVEL_WARNING;
            case DEBUG:
                return AEP_LOG_LEVEL_DEBUG;
            case VERBOSE:
                return AEP_LOG_LEVEL_VERBOSE;
        }

        return AEP_LOG_LEVEL_DEBUG;
    }

    static MobilePrivacyStatus privacyStatusFromString(final String privacyStatusString) {
        if (privacyStatusString.equals(AEP_PRIVACY_STATUS_OPT_IN)) {
            return MobilePrivacyStatus.OPT_IN;
        } else if (privacyStatusString.equals(AEP_PRIVACY_STATUS_OPT_OUT)) {
            return MobilePrivacyStatus.OPT_OUT;
        }

        return MobilePrivacyStatus.UNKNOWN;
    }

    static String stringFromPrivacyStatus(final MobilePrivacyStatus privacyStatus) {
        if (privacyStatus == MobilePrivacyStatus.OPT_IN) {
            return AEP_PRIVACY_STATUS_OPT_IN;
        } else if (privacyStatus == MobilePrivacyStatus.OPT_OUT) {
            return AEP_PRIVACY_STATUS_OPT_OUT;
        }

        return AEP_PRIVACY_STATUS_UNKNOWN;
    }

    static InitOptions initOptionsFromMap(final Object arguments) {
        if (!(arguments instanceof Map)) {
            return null;
        }

        Map argumentsAsMap = (Map) arguments;

        Map<String, Object> initOptionsMap = getNullableMap(argumentsAsMap, "initOptions");
        if (initOptionsMap == null) {
            return null;
        }
        String appId = getNullableString(initOptionsMap, APPID_KEY);
        Boolean lifecycleAutomaticTrackingEnabled = getNullableBoolean(initOptionsMap, LIFECYCLE_AUTOMATIC_TRACKING_KEY);
        Map<String, String> lifecycleAdditionalContextData = getNullableStringMap(initOptionsMap, LIFECYCLE_ADDITIONAL_CONTEXTDATA_KEY);

        InitOptions options;
        if (appId != null) {
            options = InitOptions.configureWithAppID(appId);
        } else {
            options = new InitOptions();
        }
        if (lifecycleAutomaticTrackingEnabled != null) 
        {  
          options.setLifecycleAutomaticTrackingEnabled(lifecycleAutomaticTrackingEnabled);
        }
        options.setLifecycleAdditionalContextData(lifecycleAdditionalContextData);

        return options;
    }

    // Helper methods

    private static String getNullableString(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof String) ? (String) data.get(key) : null;
    }

    private static Map getNullableMap(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof Map) ? (Map) data.get(key) : null;
    }

    private static Boolean getNullableBoolean(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof Boolean) ? (Boolean) data.get(key) : null;
    }

    private static Map<String, String> getNullableStringMap(final Map data, final String key) {
    if (!data.containsKey(key) || !(data.get(key) instanceof Map)) {
        return null;
    }

    Map rawMap = (Map) data.get(key);

    if (rawMap == null || !(rawMap instanceof Map)) {
       return null;
    }
  
    for (Object entryObj : rawMap.entrySet()) {
        Map.Entry entry = (Map.Entry) entryObj;
        if (!(entry.getKey() instanceof String) || !(entry.getValue() instanceof String)) {
            return null;
        }
    }

    return (Map<String, String>) rawMap;
  }
}
