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

#import "FlutterAEPIdentityDataBridge.h"

// Visitor ID Auth State
static NSString* const AEP_VISITOR_AUTH_STATE_AUTHENTICATED = @"AEP_VISITOR_AUTH_STATE_AUTHENTICATED";
static NSString* const AEP_VISITOR_AUTH_STATE_LOGGED_OUT = @"AEP_VISITOR_AUTH_STATE_LOGGED_OUT";
static NSString* const AEP_VISITOR_AUTH_STATE_UNKNOWN = @"AEP_VISITOR_AUTH_STATE_UNKNOWN";

// Visitor ID
static NSString* const VISITOR_ID_ID_ORIGIN_KEY = @"origin";
static NSString* const VISITOR_ID_ID_TYPE_KEY = @"type";
static NSString* const VISITOR_ID_ID_KEY = @"identifier";
static NSString* const VISITOR_ID_AUTH_STATE_KEY = @"authenticationState";

@implementation FlutterAEPIdentityDataBridge

+ (NSDictionary *)dictionaryFromVisitorId: (id<AEPIdentifiable>) visitorId {
    NSMutableDictionary *visitorIdDict = [NSMutableDictionary dictionary];
    visitorIdDict[VISITOR_ID_ID_ORIGIN_KEY] = visitorId.origin;
    visitorIdDict[VISITOR_ID_ID_TYPE_KEY] = visitorId.type;
    visitorIdDict[VISITOR_ID_ID_KEY] = visitorId.identifier;
    visitorIdDict[VISITOR_ID_AUTH_STATE_KEY] = [FlutterAEPIdentityDataBridge stringFromAuthState:visitorId.authenticationState];

    return visitorIdDict;
}

+ (NSString *)stringFromAuthState: (AEPMobileVisitorAuthState) authState {
    switch (authState) {
        case AEPMobileVisitorAuthStateAuthenticated:
            return AEP_VISITOR_AUTH_STATE_AUTHENTICATED;
        case AEPMobileVisitorAuthStateLoggedOut:
            return AEP_VISITOR_AUTH_STATE_LOGGED_OUT;
        default:
            return AEP_VISITOR_AUTH_STATE_UNKNOWN;
    }
}

+ (AEPMobileVisitorAuthState) authStateFromString: (NSString *) authStateString {
    if ([authStateString isEqualToString:AEP_VISITOR_AUTH_STATE_AUTHENTICATED]) {
        return AEPMobileVisitorAuthStateAuthenticated;
    } else if ([authStateString isEqualToString:AEP_VISITOR_AUTH_STATE_LOGGED_OUT]) {
        return AEPMobileVisitorAuthStateLoggedOut;
    }

    return AEPMobileVisitorAuthStateUnknown;
}


@end
