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

#import "FlutterAEPCoreDataBridge.h"
#import <Flutter/Flutter.h>


@implementation FlutterAEPCoreDataBridge

// Logging mode
static NSString* const AEP_LOG_LEVEL_ERROR = @"AEP_LOG_LEVEL_ERROR";
static NSString* const AEP_LOG_LEVEL_WARNING = @"AEP_LOG_LEVEL_WARNING";
static NSString* const AEP_LOG_LEVEL_DEBUG = @"AEP_LOG_LEVEL_DEBUG";
static NSString* const AEP_LOG_LEVEL_TRACE = @"AEP_LOG_LEVEL_TRACE";

// Privacy Status
static NSString* const AEP_PRIVACY_STATUS_OPT_IN = @"AEP_PRIVACY_STATUS_OPT_IN";
static NSString* const AEP_PRIVACY_STATUS_OPT_OUT = @"AEP_PRIVACY_STATUS_OPT_OUT";
static NSString* const AEP_PRIVACY_STATUS_UNKNOWN = @"AEP_PRIVACY_STATUS_UNKNOWN";

+ (AEPPrivacyStatus)privacyStatusFromString: (NSString *) statusString {
    if ([statusString isEqualToString:AEP_PRIVACY_STATUS_OPT_IN]) {
        return AEPPrivacyStatusOptedIn;
    } else if ([statusString isEqualToString:AEP_PRIVACY_STATUS_OPT_OUT]) {
        return AEPPrivacyStatusOptedOut;
    }

    return AEPPrivacyStatusUnknown;
}

+ (AEPLogLevel) logLevelFromString: (NSString *) logLevelString {
    if ([logLevelString isEqualToString:AEP_LOG_LEVEL_ERROR]) {
        return AEPLogLevelError;
    } else if ([logLevelString isEqualToString:AEP_LOG_LEVEL_WARNING]) {
        return AEPLogLevelWarning;
    } else if ([logLevelString isEqualToString:AEP_LOG_LEVEL_DEBUG]) {
        return AEPLogLevelDebug;
    } else if ([logLevelString isEqualToString:AEP_LOG_LEVEL_TRACE]) {
        return AEPLogLevelTrace;
    }

    return AEPLogLevelDebug;
}

+ (NSString *)stringFromPrivacyStatus: (AEPPrivacyStatus) status {
    switch (status) {
        case AEPPrivacyStatusOptedIn:
            return AEP_PRIVACY_STATUS_OPT_IN;
            break;
        case AEPPrivacyStatusOptedOut:
            return AEP_PRIVACY_STATUS_OPT_OUT;
            break;
        case AEPPrivacyStatusUnknown:
            return AEP_PRIVACY_STATUS_UNKNOWN;
            break;
    }
}

+ (NSString *)stringFromLogLevel: (AEPLogLevel) logLevel {
    switch (logLevel) {
        case AEPLogLevelError:
            return AEP_LOG_LEVEL_ERROR;
        case AEPLogLevelWarning:
            return AEP_LOG_LEVEL_WARNING;
        case AEPLogLevelDebug:
            return AEP_LOG_LEVEL_DEBUG;
        case AEPLogLevelTrace:
            return AEP_LOG_LEVEL_TRACE;
    }
}

+ (NSDictionary *)sanitizeDictionaryToContainClass: (Class) type WithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *sanitizedDict = [NSMutableDictionary dictionary];

    for (id key in dict) {
        id obj = [dict objectForKey:key];
        if ([key isKindOfClass:type] && [obj isKindOfClass:type]) {
            sanitizedDict[key] = obj;
        }
    }

    return sanitizedDict;
}

+ (AEPInitOptions *)initOptionsFromMap:(id)map {
    if (![map isKindOfClass:[FlutterMethodCall class]]) {
        return nil;
    }

    FlutterMethodCall *call = (FlutterMethodCall *)map;
    NSDictionary *arguments = call.arguments;
    if (![arguments isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSDictionary *initOptionsMap = arguments[@"initOptions"];
    if (![initOptionsMap isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSString *appId = initOptionsMap[@"appId"];
    NSNumber *lifecycleAutomaticTrackingEnabled = initOptionsMap[@"lifecycleAutomaticTrackingEnabled"];
    NSDictionary *lifecycleAdditionalContextData = initOptionsMap[@"lifecycleAdditionalContextData"];
    NSString *appGroup = initOptionsMap[@"appGroupIOS"];

    AEPInitOptions *initOptions;
    if (appId != nil && [appId isKindOfClass:[NSString class]]) {
        initOptions = [[AEPInitOptions alloc] initWithAppId:appId];
    } else {
        initOptions = [[AEPInitOptions alloc] init];
    }
    if (lifecycleAutomaticTrackingEnabled != nil && [lifecycleAutomaticTrackingEnabled isKindOfClass:[NSNumber class]] ) {
        initOptions.lifecycleAutomaticTrackingEnabled = [lifecycleAutomaticTrackingEnabled boolValue];
    }
    if (lifecycleAdditionalContextData != nil && [lifecycleAdditionalContextData isKindOfClass:[NSDictionary class]]) {
        initOptions.lifecycleAdditionalContextData = lifecycleAdditionalContextData;
    } 
    if (appGroup != nil && [appGroup isKindOfClass:[NSString class]]) {
        initOptions.appGroup = appGroup;
    }

    return initOptions;
}

@end
