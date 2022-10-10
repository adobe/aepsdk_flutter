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

package com.adobe.marketing.mobile.flutter.flutter_aepedgeidentity;

import com.adobe.marketing.mobile.edge.identity.IdentityMap;
import com.adobe.marketing.mobile.edge.identity.IdentityItem;
import com.adobe.marketing.mobile.edge.identity.AuthenticatedState;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.util.Log;

class FlutterAEPEdgeIdentityDataBridge {

    private final static String ID_KEY = "id";
    private final static String IS_PRIMARY_KEY = "primary";
    private final static String AEP_AUTH_STATE_KEY = "authenticatedState";
    private static final String IDENTITY_MAP_KEY = "identityMap";

    static Map mapFromIdentityMap(final IdentityMap map) {

        if (map == null || map.isEmpty()){
            return null;
        }

        Map identityMapToMap = new HashMap();

        for (String namespace : map.getNamespaces()) {
            List<IdentityItem> identityitems = map.getIdentityItemsForNamespace(namespace);

            List<Map<String, Object>> identityItemsList = new ArrayList();

            for (IdentityItem item : identityitems) {
                Map identityItemAsMap = new HashMap();

                identityItemAsMap.put(IS_PRIMARY_KEY, item.isPrimary());
                identityItemAsMap.put(AEP_AUTH_STATE_KEY, item.getAuthenticatedState().getName());
                identityItemAsMap.put(ID_KEY, item.getId());

                identityItemsList.add(identityItemAsMap);
            }

            if (identityItemsList.size() != 0) {
                identityMapToMap.put(namespace, identityItemsList);
            }
        }
        return identityMapToMap;
    }

    @SuppressLint("LongLogTag")
    static IdentityMap mapToIdentityMap(final Map<String, Map<String, List<Map<String, Object>>>>map) {

        if (map == null || map.isEmpty()) {
            return null;
        }

        IdentityMap identityMap = new IdentityMap();

        Map<String, List<Map<String, Object>>> genericIdentityMap = map.get(IDENTITY_MAP_KEY);

        for (Map.Entry<String, List<Map<String, Object>>> entry : genericIdentityMap.entrySet()) {

            String namespace = entry.getKey();

            List<Map<String, Object>> namespaceList = null;

            try {
                namespaceList = (ArrayList) genericIdentityMap.get(namespace);

            } catch (ClassCastException e) {
                Log.d("FlutterAEPEdgeIdentityDataBridge", "mapToIdentityMap: " + e);
            }

            if (namespaceList == null) {
                continue;
            }

            for (int i = 0; i < namespaceList.size(); i++) {
                Map identityItemAsMap = namespaceList.get(i);
                IdentityItem item = mapToIdentityItem(identityItemAsMap);
                if (item != null) {
                    identityMap.addItem(item, namespace);
                }
            }
        }
        return identityMap;
      }

    static IdentityItem mapToIdentityItem(Map map) {
        if (map == null || map.isEmpty()) {
            return null;
        }

        String id = getNullableString(map, ID_KEY);
        // verify id is not null as this is not an accepted value for ids
        if (id == null) {
            return null;
        }

        return new IdentityItem(id, getAuthenticatedState(map, AEP_AUTH_STATE_KEY), getBoolean(map, IS_PRIMARY_KEY));
    }

    // Helper methods

    private static AuthenticatedState getAuthenticatedState(final Map data, final String key) {
        return AuthenticatedState.fromString(getNullableString(data, key));
    }

    private static String getNullableString(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof String) ? (String) data.get(key) : null;
    }

    private static Boolean getBoolean(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof Boolean) ? (Boolean) data.get(key) : null;
    }
}
