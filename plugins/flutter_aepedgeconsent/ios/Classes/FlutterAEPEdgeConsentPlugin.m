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

#import "FlutterAEPEdgeConsentPlugin.h"
@import AEPEdgeConsent;
@import AEPCore;

@implementation FlutterAEPEdgeConsentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aepedgeconsent"
            binaryMessenger:[registrar messenger]];
  FlutterAEPEdgeConsentPlugin* instance = [[FlutterAEPEdgeConsentPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"extensionVersion" isEqualToString:call.method]) {
      result([AEPMobileEdgeConsent extensionVersion]);
  } else if ([@"getConsents" isEqualToString:call.method]) {
    [self handleGetConsent:call result:result];
  } else if ([@"updateConsents" isEqualToString:call.method]) {
    [self handleUpdateConsent:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)handleGetConsent:(FlutterMethodCall *) call result:(FlutterResult)result {
     [AEPMobileEdgeConsent getConsents:^(NSDictionary* consents, NSError* error) {
      if (error && error.code != AEPErrorNone) {
         result([self flutterErrorFromNSError:error]);
         return;
      }
      result(consents);
  }];
}

- (void)handleUpdateConsent:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileEdgeConsent updateWithConsents:call.arguments];
    result(nil);
}

- (FlutterError *)flutterErrorFromNSError:(NSError *) error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                         message:error.localizedDescription
                         details:error.domain];
}
@end
