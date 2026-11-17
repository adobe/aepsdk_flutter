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

#import "FlutterAEPAssurancePlugin.h"
@import AEPAssurance;
@import AEPCore;

@implementation FlutterAEPAssurancePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aepassurance"
            binaryMessenger:[registrar messenger]];
  FlutterAEPAssurancePlugin* instance = [[FlutterAEPAssurancePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"extensionVersion" isEqualToString:call.method]) {
      result([AEPMobileAssurance extensionVersion]);
  } else if ([@"startSession" isEqualToString:call.method]) {
      NSString *url = (NSString *) call.arguments;
      [AEPMobileAssurance startSessionWithUrl:[NSURL URLWithString: url]];
      result(nil);
  } else {
      result(FlutterMethodNotImplemented);
  }
}

@end
