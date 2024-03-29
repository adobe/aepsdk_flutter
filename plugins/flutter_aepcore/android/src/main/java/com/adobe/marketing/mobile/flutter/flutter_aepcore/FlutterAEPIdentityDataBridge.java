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

import com.adobe.marketing.mobile.VisitorID;

import java.util.HashMap;
import java.util.Map;

public class FlutterAEPIdentityDataBridge {

    // Visitor ID Auth State
    private static final String AEP_VISITOR_AUTH_STATE_AUTHENTICATED = "AEP_VISITOR_AUTH_STATE_AUTHENTICATED";
    private static final String AEP_VISITOR_AUTH_STATE_LOGGED_OUT = "AEP_VISITOR_AUTH_STATE_LOGGED_OUT";
    private static final String AEP_VISITOR_AUTH_STATE_UNKNOWN = "AEP_VISITOR_AUTH_STATE_UNKNOWN";

    // Visitor ID
    private static final String AEP_VISITOR_ID_ORIGIN = "idOrigin";
    private static final String AEP_VISITOR_ID_TYPE = "idType";
    private static final String AEP_VISITOR_IDENTIFIER = "identifier";
    private static final String AEP_VISITOR_AUTH_STATE = "authenticationState";

    /**
     * Takes in a {@link String} and returns the associated enum {authenticated, logged_out, unknown}
     *
     * @param authStateString
     * @return The @{link VisitorID.AuthenticationState} authentication state
     */
    public static VisitorID.AuthenticationState authenticationStateFromString(final String authStateString) {
        if (authStateString == null) {
            return VisitorID.AuthenticationState.UNKNOWN;
        }

        if (authStateString.equals(AEP_VISITOR_AUTH_STATE_AUTHENTICATED)) {
            return VisitorID.AuthenticationState.AUTHENTICATED;
        } else if (authStateString.equals(AEP_VISITOR_AUTH_STATE_LOGGED_OUT)) {
            return VisitorID.AuthenticationState.LOGGED_OUT;
        }

        return VisitorID.AuthenticationState.UNKNOWN;
    }

    private static String stringFromAuthState(final VisitorID.AuthenticationState authenticationState) {
        if (authenticationState == null) {
            return AEP_VISITOR_AUTH_STATE_UNKNOWN;
        }

        if (authenticationState == VisitorID.AuthenticationState.AUTHENTICATED) {
            return AEP_VISITOR_AUTH_STATE_AUTHENTICATED;
        } else if (authenticationState == VisitorID.AuthenticationState.LOGGED_OUT) {
            return AEP_VISITOR_AUTH_STATE_LOGGED_OUT;
        }

        return AEP_VISITOR_AUTH_STATE_UNKNOWN;
    }

    /**
     * Converts a {@link VisitorID} into a {@link Map}
     * @param visitorID The visitorID object
     * @return A {@link Map} that represents the visitorID
     */
    public static Map mapFromVisitorIdentifier(final VisitorID visitorID) {
        if (visitorID == null) {
            return null;
        }

        Map<String, String> visitorIDMap = new HashMap<>();
        visitorIDMap.put(AEP_VISITOR_ID_ORIGIN, visitorID.getIdOrigin());
        visitorIDMap.put(AEP_VISITOR_ID_TYPE, visitorID.getIdType());
        visitorIDMap.put(AEP_VISITOR_IDENTIFIER, visitorID.getId());
        visitorIDMap.put(AEP_VISITOR_AUTH_STATE, stringFromAuthState(visitorID.getAuthenticationState()));

        return visitorIDMap;
    }

}
