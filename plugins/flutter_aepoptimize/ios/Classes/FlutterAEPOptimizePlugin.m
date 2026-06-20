/*
Copyright 2025 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

@import AEPOptimize;
@import AEPCore;
@import Foundation;
#import "FlutterAEPOptimizePlugin.h"
#import "FlutterAEPOptimizeDataBridge.h"

@interface FlutterAEPOptimizePlugin ()
@property(nonatomic, strong) FlutterMethodChannel *channel;
@end

@implementation FlutterAEPOptimizePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"flutter_aepoptimize"
                                    binaryMessenger:[registrar messenger]];
    FlutterAEPOptimizePlugin *instance = [[FlutterAEPOptimizePlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"extensionVersion" isEqualToString:call.method]) {
        result([AEPMobileOptimize extensionVersion]);
    } else if ([@"updatePropositions" isEqualToString:call.method]) {
        [self handleUpdatePropositions:call result:result];
    } else if ([@"getPropositions" isEqualToString:call.method]) {
        [self handleGetPropositions:call result:result];
    } else if ([@"registerOnPropositionsUpdate" isEqualToString:call.method]) {
        [self handleRegisterOnPropositionsUpdate:result];
    } else if ([@"clearCachedPropositions" isEqualToString:call.method]) {
        [AEPMobileOptimize clearCachedPropositions];
        result(nil);
    } else if ([@"offerDisplayed" isEqualToString:call.method]) {
        [self handleOfferDisplayed:call result:result];
    } else if ([@"offerTapped" isEqualToString:call.method]) {
        [self handleOfferTapped:call result:result];
    } else if ([@"generateDisplayInteractionXdm" isEqualToString:call.method]) {
        [self handleGenerateDisplayInteractionXdm:call result:result];
    } else if ([@"generateTapInteractionXdm" isEqualToString:call.method]) {
        [self handleGenerateTapInteractionXdm:call result:result];
    } else if ([@"generateReferenceXdm" isEqualToString:call.method]) {
        [self handleGenerateReferenceXdm:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - API Handlers

- (void)handleUpdatePropositions:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    NSArray<AEPDecisionScope *> *scopes = [FlutterAEPOptimizeDataBridge decisionScopesFromArray:arguments[@"decisionScopes"]];

    if (!scopes || scopes.count == 0) {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"decisionScopes is required"
                                   details:nil]);
        return;
    }

    NSDictionary *xdm = arguments[@"xdm"];
    NSDictionary *data = arguments[@"data"];
    NSNumber *timeoutNumber = arguments[@"timeout"];

    if (timeoutNumber && ![timeoutNumber isKindOfClass:[NSNull class]]) {
        NSTimeInterval timeout = [timeoutNumber doubleValue];
        [AEPMobileOptimize updatePropositionsFor:scopes
                                         withXdm:xdm
                                         andData:data
                                         timeout:timeout
                                                 :^(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> * _Nullable propositions, NSError * _Nullable error) {
            if (error) {
                result([self flutterErrorFromNSError:error]);
            } else {
                result([FlutterAEPOptimizeDataBridge dictionaryFromPropositionsMap:propositions]);
            }
        }];
    } else {
        [AEPMobileOptimize updatePropositionsFor:scopes
                                         withXdm:xdm
                                         andData:data
                                                 :^(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> * _Nullable propositions, NSError * _Nullable error) {
            if (error) {
                result([self flutterErrorFromNSError:error]);
            } else {
                result([FlutterAEPOptimizeDataBridge dictionaryFromPropositionsMap:propositions]);
            }
        }];
    }
}

- (void)handleGetPropositions:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    NSArray<AEPDecisionScope *> *scopes = [FlutterAEPOptimizeDataBridge decisionScopesFromArray:arguments[@"decisionScopes"]];

    if (!scopes || scopes.count == 0) {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"decisionScopes is required"
                                   details:nil]);
        return;
    }

    NSNumber *timeoutNumber = arguments[@"timeout"];

    void (^completionHandler)(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> * _Nullable, NSError * _Nullable) =
        ^(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> * _Nullable propositions, NSError * _Nullable error) {
            if (error) {
                result([self flutterErrorFromNSError:error]);
            } else {
                result([FlutterAEPOptimizeDataBridge dictionaryFromPropositionsMap:propositions]);
            }
        };

    if (timeoutNumber && ![timeoutNumber isKindOfClass:[NSNull class]]) {
        [AEPMobileOptimize getPropositionsFor:scopes timeout:[timeoutNumber doubleValue] :completionHandler];
    } else {
        [AEPMobileOptimize getPropositionsFor:scopes :completionHandler];
    }
}

- (void)handleRegisterOnPropositionsUpdate:(FlutterResult)result {
    [AEPMobileOptimize onPropositionsUpdateWithPerform:^(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> * _Nonnull propositions) {
        NSDictionary *encoded = [FlutterAEPOptimizeDataBridge dictionaryFromPropositionsMap:propositions];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.channel invokeMethod:@"onPropositionsUpdate" arguments:encoded];
        });
    }];
    result(nil);
}

- (void)handleOfferDisplayed:(FlutterMethodCall *)call result:(FlutterResult)result {
    AEPOffer *offer = [FlutterAEPOptimizeDataBridge offerFromDictionary:call.arguments];
    if (offer) {
        [offer displayed];
    }
    result(nil);
}

- (void)handleOfferTapped:(FlutterMethodCall *)call result:(FlutterResult)result {
    AEPOffer *offer = [FlutterAEPOptimizeDataBridge offerFromDictionary:call.arguments];
    if (offer) {
        [offer tapped];
    }
    result(nil);
}

- (void)handleGenerateDisplayInteractionXdm:(FlutterMethodCall *)call result:(FlutterResult)result {
    AEPOffer *offer = [FlutterAEPOptimizeDataBridge offerFromDictionary:call.arguments];
    if (offer) {
        result([offer generateDisplayInteractionXdm]);
    } else {
        result(nil);
    }
}

- (void)handleGenerateTapInteractionXdm:(FlutterMethodCall *)call result:(FlutterResult)result {
    AEPOffer *offer = [FlutterAEPOptimizeDataBridge offerFromDictionary:call.arguments];
    if (offer) {
        result([offer generateTapInteractionXdm]);
    } else {
        result(nil);
    }
}

- (void)handleGenerateReferenceXdm:(FlutterMethodCall *)call result:(FlutterResult)result {
    AEPOptimizeProposition *proposition = [FlutterAEPOptimizeDataBridge propositionFromDictionary:call.arguments];
    if (proposition) {
        result([proposition generateReferenceXdm]);
    } else {
        result(nil);
    }
}

#pragma mark - Helpers

- (FlutterError *)flutterErrorFromNSError:(NSError *)error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                               message:error.localizedDescription
                               details:error.domain];
}

@end
