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
@import AEPCore;
#import "FlutterAEPCorePlugin.h"
#import "FlutterAEPIdentityPlugin.h"
#import "FlutterAEPLifecyclePlugin.h"
#import "FlutterAEPSignalPlugin.h"
#import "AEPExtensionEvent+Flutter.h"
#import "FlutterAEPCoreDataBridge.h"

@implementation FlutterAEPCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aepcore"
            binaryMessenger:[registrar messenger]];
  FlutterAEPCorePlugin* instance = [[FlutterAEPCorePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  [FlutterAEPIdentityPlugin registerWithRegistrar: registrar];
  [FlutterAEPLifecyclePlugin registerWithRegistrar: registrar];
  [FlutterAEPSignalPlugin registerWithRegistrar: registrar];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"extensionVersion" isEqualToString:call.method]) {
        result([AEPMobileCore extensionVersion]);
    } else if ([@"track" isEqualToString:call.method]) {
        [self handleTrackCall:call];
        result(nil);
    } else if ([@"setAdvertisingIdentifier" isEqualToString:call.method]) {
        NSString *aid = call.arguments;
        [AEPMobileCore setAdvertisingIdentifier:aid];
        result(nil);
    } else if ([@"dispatchEvent" isEqualToString:call.method]) {
        [self handleDispatchEvent:call];
    } else if ([@"dispatchEventWithResponseCallback" isEqualToString:call.method]) {
        [self handleDispatchEventWithResponseCallback:call result:result];
    } else if ([@"getSdkIdentities" isEqualToString:call.method]) {
        [self handleGetSdkIdentities:call result:result];
    } else if ([@"getPrivacyStatus" isEqualToString:call.method]) {
        [self handleGetPrivacyStatus:call result:result];
    } else if ([@"setLogLevel" isEqualToString:call.method]) {
        NSString *logLevel = call.arguments;
        [AEPMobileCore setLogLevel:[FlutterAEPCoreDataBridge logLevelFromString:logLevel]];
        result(nil);
    } else if ([@"updateConfiguration" isEqualToString:call.method]) {
        NSDictionary *configUpdate = call.arguments;
        [AEPMobileCore updateConfiguration:configUpdate];
        result(nil);
    } else if ([@"clearUpdatedConfiguration" isEqualToString:call.method]){
        [AEPMobileCore clearUpdatedConfiguration];
        result(nil);
    } else if ([@"setPrivacyStatus" isEqualToString:call.method]) {
        [AEPMobileCore setPrivacyStatus:[FlutterAEPCoreDataBridge privacyStatusFromString:call.arguments]];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleTrackCall:(FlutterMethodCall *) call {
    NSDictionary *dict = (NSDictionary *) call.arguments;
    NSString *type = (NSString *) dict[@"type"];
    NSString *name = (NSString *) dict[@"name"];
    NSDictionary *data = (NSDictionary *) dict[@"data"];

    if ([type isEqualToString:@"state"]) {
        [AEPMobileCore trackState:name data:data];
    } else if ([type isEqualToString:@"action"]) {
        [AEPMobileCore trackAction:name data:data];
    }
    
}

- (void)handleDispatchEvent:(FlutterMethodCall *) call {
    NSDictionary *eventDict = (NSDictionary *) call.arguments;
    AEPEvent *event = [AEPEvent eventFromDictionary:eventDict];
    [AEPMobileCore dispatch:event];
}

- (void)handleDispatchEventWithResponseCallback:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *eventDict = (NSDictionary *) call.arguments;
    AEPEvent *event = [AEPEvent eventFromDictionary:eventDict];
    
    [AEPMobileCore dispatch:event timeout:1 responseCallback:^(AEPEvent * _Nullable responseEvent) {
        result([AEPEvent dictionaryFromEvent:responseEvent]);
    }];
}

- (void)handleGetSdkIdentities:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileCore getSdkIdentities:^(NSString * _Nullable content, NSError * _Nullable error) {
        result(content);
    }];
}

- (void)handleGetPrivacyStatus:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileCore getPrivacyStatus:^(enum AEPPrivacyStatus status) {
        result([FlutterAEPCoreDataBridge stringFromPrivacyStatus:status]);
    }];
}

- (FlutterError *)flutterErrorFromNSError:(NSError *) error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                             message:error.localizedDescription
                             details:error.domain];
}

@end
