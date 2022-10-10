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

@import AEPEdgeIdentity;
@import AEPCore;
@import Foundation;
#import "FlutterAEPEdgeIdentityPlugin.h"
#import "FlutterAEPEdgeIdentityDataBridge.h"

@implementation FlutterAEPEdgeIdentityPlugin
             
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aepedgeidentity"
            binaryMessenger:[registrar messenger]];
  FlutterAEPEdgeIdentityPlugin* instance = [[FlutterAEPEdgeIdentityPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"extensionVersion" isEqualToString:call.method]) {
     result([AEPMobileEdgeIdentity extensionVersion]);
  } else if ([@"getExperienceCloudId" isEqualToString:call.method]) {
     [self handleGetExperinceCloudId:call result:result];
  } else if ([@"getUrlVariables" isEqualToString:call.method]) {
     [self handleGetUrlVariables:call result:result];
  } else if ([@"getIdentities" isEqualToString:call.method]) {
     [self handleGetIdentities:call result:result]; 
  } else if ([@"updateIdentities" isEqualToString:call.method]) {
     [self handleUpdateIdentities:call result:result]; }
    else if ([@"removeIdentities" isEqualToString:call.method]) {
     [self handleRemoveIdentities:call result:result]; }
     else {
      result(FlutterMethodNotImplemented);
  }
}
    
- (void)handleGetExperinceCloudId:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileEdgeIdentity getExperienceCloudId:^(NSString * _Nullable experienceCloudId, NSError * _Nullable error) {
        if (error && error.code != AEPErrorNone) {
         result([self flutterErrorFromNSError:error]);
         return;
      }
         result(experienceCloudId);
    }];
    }

- (void)handleGetUrlVariables:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileEdgeIdentity getUrlVariables:^(NSString * _Nullable urlVariables, NSError * _Nullable error) {
        if (error && error.code != AEPErrorNone) {
         result([self flutterErrorFromNSError:error]);
         return;
      }
         result(urlVariables);
    }];
    }

- (void)handleGetIdentities:(FlutterMethodCall *) call result:(FlutterResult)result {
    [AEPMobileEdgeIdentity getIdentities:^(AEPIdentityMap * _Nullable identityMap, NSError * _Nullable error) {
        
        if (error) {
            result([self flutterErrorFromNSError:error]);
            return;
        } else {
            result([FlutterAEPEdgeIdentityDataBridge dictionaryFromIdentityMap:identityMap]);
        }
    }];
    }

-   (void)handleUpdateIdentities:(FlutterMethodCall *) call result:(FlutterResult)result {
    
    NSDictionary *map = call.arguments;
  
    AEPIdentityMap *identityMap = [FlutterAEPEdgeIdentityDataBridge dictionaryToIdentityMap:map];

    [AEPMobileEdgeIdentity updateIdentities:(AEPIdentityMap * _Nonnull) identityMap];
}

-  (void)handleRemoveIdentities:(FlutterMethodCall *) call result:(FlutterResult)result {
    NSDictionary *item = call.arguments[@"item"];
    NSString *namespace = call.arguments[@"namespace"];
    
    AEPIdentityItem *identityItem = [FlutterAEPEdgeIdentityDataBridge dictionaryToIdentityItem:item];
    
    if (!identityItem || !namespace) {
     return;
     }

     [AEPMobileEdgeIdentity removeIdentityItem:(AEPIdentityItem * _Nonnull) identityItem withNamespace:(NSString * _Nonnull) namespace];
}

- (FlutterError *)flutterErrorFromNSError:(NSError *) error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                         message:error.localizedDescription
                         details:error.domain];
}
@end
