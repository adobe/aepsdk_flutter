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
#import "FlutterAEPUserProfilePlugin.h"
@import AEPUserProfile;
@import AEPCore;

@implementation FlutterAEPUserProfilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aepuserprofile"
            binaryMessenger:[registrar messenger]];
    FlutterAEPUserProfilePlugin* instance = [[FlutterAEPUserProfilePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"extensionVersion" isEqualToString:call.method]) {
        result([AEPMobileUserProfile extensionVersion]);
    } else if ([@"getUserAttributes" isEqualToString:call.method]) {
        [self handleGetUserAttributes:call result:result];
    } else if ([@"removeUserAttributes" isEqualToString:call.method]) {
        NSArray<NSString*>* userAttributes = call.arguments;
        [AEPMobileUserProfile removeUserAttributesWithAttributeNames:userAttributes];
        result(nil);
    } else if ([@"updateUserAttributes" isEqualToString:call.method]) {
        NSDictionary *attributeMap = call.arguments;
        [AEPMobileUserProfile updateUserAttributesWithAttributeDict:attributeMap];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleGetUserAttributes:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSArray<NSString*>* attributes = call.arguments;
    [AEPMobileUserProfile getUserAttributesWithAttributeNames:attributes completion:^(NSDictionary* _Nullable userAttributes, AEPError error) {
        if(userAttributes != nil) {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userAttributes options:0 error:nil];
            result([[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        } else {
            FlutterError* error = [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", AEPErrorUnexpected] message:@"Unexpected error" details:nil];
            result(error);
        }
    }];
}

@end
