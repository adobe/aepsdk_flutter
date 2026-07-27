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

#import "FlutterAEPOptimizeDataBridge.h"

@implementation FlutterAEPOptimizeDataBridge

#pragma mark - DecisionScope

+ (NSArray<AEPDecisionScope *> *)decisionScopesFromArray:(NSArray *)array {
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }

    NSMutableArray<AEPDecisionScope *> *scopes = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NSString *name = dict[@"name"];
        if (name && [name isKindOfClass:[NSString class]]) {
            [scopes addObject:[[AEPDecisionScope alloc] initWithName:name]];
        }
    }
    return scopes;
}

#pragma mark - Proposition Map

+ (NSDictionary *)dictionaryFromPropositionsMap:(NSDictionary<AEPDecisionScope *, AEPOptimizeProposition *> *)propositions {
    if (!propositions) {
        return nil;
    }

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [propositions enumerateKeysAndObjectsUsingBlock:^(AEPDecisionScope *scope, AEPOptimizeProposition *proposition, BOOL *stop) {
        result[scope.name] = [self dictionaryFromProposition:proposition];
    }];
    return result;
}

#pragma mark - Proposition

+ (NSDictionary *)dictionaryFromProposition:(AEPOptimizeProposition *)proposition {
    if (!proposition) {
        return nil;
    }

    NSMutableArray *offersArray = [NSMutableArray array];
    for (AEPOffer *offer in proposition.offers) {
        [offersArray addObject:[self dictionaryFromOffer:offer]];
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = proposition.id;
    dict[@"offers"] = offersArray;
    dict[@"scope"] = proposition.scope;
    dict[@"scopeDetails"] = proposition.scopeDetails ?: @{};
    dict[@"activity"] = proposition.activity ?: @{};
    dict[@"placement"] = proposition.placement ?: @{};
    return dict;
}

+ (AEPOptimizeProposition *)propositionFromDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    return [AEPOptimizeProposition initFromData:dict];
}

#pragma mark - Offer

+ (NSDictionary *)dictionaryFromOffer:(AEPOffer *)offer {
    if (!offer) {
        return nil;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = offer.id;
    dict[@"etag"] = offer.etag ?: @"";
    dict[@"score"] = @(offer.score);
    dict[@"schema"] = offer.schema ?: @"";
    dict[@"meta"] = offer.meta ?: [NSNull null];
    dict[@"type"] = @((int)offer.type);
    dict[@"language"] = offer.language ?: [NSNull null];
    dict[@"content"] = offer.content ?: @"";
    dict[@"characteristics"] = offer.characteristics ?: [NSNull null];
    return dict;
}

+ (AEPOptimizeProposition *)propositionFromOfferTrackingDictionary:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSString *propositionId = [dict[@"propositionId"] isKindOfClass:[NSString class]] ? dict[@"propositionId"] : @"";
    NSString *propositionScope = [dict[@"propositionScope"] isKindOfClass:[NSString class]] ? dict[@"propositionScope"] : @"";
    NSDictionary *scopeDetails = [dict[@"propositionScopeDetails"] isKindOfClass:[NSDictionary class]] ? dict[@"propositionScopeDetails"] : @{};
    NSDictionary *activity = [dict[@"propositionActivity"] isKindOfClass:[NSDictionary class]] ? dict[@"propositionActivity"] : @{};
    NSDictionary *placement = [dict[@"propositionPlacement"] isKindOfClass:[NSDictionary class]] ? dict[@"propositionPlacement"] : @{};

    NSDictionary *propositionData = @{
        @"id": propositionId,
        @"scope": propositionScope,
        @"scopeDetails": scopeDetails,
        @"activity": activity,
        @"placement": placement,
        @"items": @[@{
            @"id": dict[@"id"] ?: @"",
            @"etag": dict[@"etag"] ?: @"",
            @"score": dict[@"score"] ?: @(0),
            @"schema": dict[@"schema"] ?: @"",
            @"meta": [dict[@"meta"] isKindOfClass:[NSDictionary class]] ? dict[@"meta"] : @{},
            @"data": @{
                @"id": dict[@"id"] ?: @"",
                @"format": [self mimeTypeFromOfferType:dict[@"type"]],
                @"content": dict[@"content"] ?: @"",
                @"language": [dict[@"language"] isKindOfClass:[NSArray class]] ? dict[@"language"] : @[],
                @"characteristics": [dict[@"characteristics"] isKindOfClass:[NSDictionary class]] ? dict[@"characteristics"] : @{}
            }
        }]
    };

    AEPOptimizeProposition *proposition = [AEPOptimizeProposition initFromData:propositionData];
    if (proposition) {
        // Access offers to trigger lazy property that sets offer.proposition = self
        (void)proposition.offers;
    }
    return proposition;
}

#pragma mark - OfferType

+ (NSString *)mimeTypeFromOfferType:(NSNumber *)typeValue {
    if (!typeValue || ![typeValue isKindOfClass:[NSNumber class]]) {
        return @"";
    }

    switch ([typeValue intValue]) {
        case 1: return @"application/json";
        case 2: return @"text/plain";
        case 3: return @"text/html";
        case 4: return @"image/*";
        default: return @"";
    }
}

@end
