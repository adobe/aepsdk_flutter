/*
Copyright 2026 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

package com.adobe.marketing.mobile.flutter.flutter_aepoptimize;

import com.adobe.marketing.mobile.optimize.DecisionScope;
import com.adobe.marketing.mobile.optimize.Offer;
import com.adobe.marketing.mobile.optimize.OfferType;
import com.adobe.marketing.mobile.optimize.OptimizeProposition;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class FlutterAEPOptimizeDataBridge {

    static List<DecisionScope> decisionScopesFromList(List<Map<String, Object>> list) {
        if (list == null) {
            return null;
        }

        List<DecisionScope> scopes = new ArrayList<>();
        for (Map<String, Object> item : list) {
            String name = (String) item.get("name");
            if (name != null) {
                scopes.add(new DecisionScope(name));
            }
        }
        return scopes;
    }

    static Map<String, Object> mapFromPropositionsMap(Map<DecisionScope, OptimizeProposition> propositions) {
        if (propositions == null) {
            return null;
        }

        Map<String, Object> result = new HashMap<>();
        for (Map.Entry<DecisionScope, OptimizeProposition> entry : propositions.entrySet()) {
            result.put(entry.getKey().getName(), mapFromProposition(entry.getValue()));
        }
        return result;
    }

    static Map<String, Object> mapFromProposition(OptimizeProposition proposition) {
        if (proposition == null) {
            return null;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("id", proposition.getId());
        map.put("scope", proposition.getScope());
        map.put("scopeDetails", proposition.getScopeDetails() != null ? proposition.getScopeDetails() : new HashMap<>());
        map.put("activity", proposition.getActivity() != null ? proposition.getActivity() : new HashMap<>());
        map.put("placement", proposition.getPlacement() != null ? proposition.getPlacement() : new HashMap<>());

        List<Map<String, Object>> offersArray = new ArrayList<>();
        if (proposition.getOffers() != null) {
            for (Offer offer : proposition.getOffers()) {
                offersArray.add(mapFromOffer(offer));
            }
        }
        map.put("items", offersArray);
        return map;
    }

    static Map<String, Object> mapFromOffer(Offer offer) {
        if (offer == null) {
            return null;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("id", offer.getId());
        map.put("etag", offer.getEtag() != null ? offer.getEtag() : "");
        map.put("score", offer.getScore());
        map.put("schema", offer.getSchema() != null ? offer.getSchema() : "");
        map.put("meta", offer.getMeta());
        map.put("type", offerTypeToInt(offer.getType()));
        map.put("language", offer.getLanguage());
        map.put("content", offer.getContent() != null ? offer.getContent() : "");
        map.put("characteristics", offer.getCharacteristics());
        return map;
    }

    @SuppressWarnings("unchecked")
    static OptimizeProposition propositionFromOfferTrackingMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }

        String propositionId = getNullableString(map, "propositionId");
        String propositionScope = getNullableString(map, "propositionScope");
        Map<String, Object> scopeDetails = getNullableMap(map, "propositionScopeDetails");
        Map<String, Object> activity = getNullableMap(map, "propositionActivity");
        Map<String, Object> placement = getNullableMap(map, "propositionPlacement");

        Map<String, Object> offerItemData = new HashMap<>();
        offerItemData.put("id", map.get("id") != null ? map.get("id") : "");
        offerItemData.put("etag", map.get("etag") != null ? map.get("etag") : "");
        offerItemData.put("score", map.get("score") != null ? map.get("score") : 0);
        offerItemData.put("schema", map.get("schema") != null ? map.get("schema") : "");

        Map<String, Object> dataPayload = new HashMap<>();
        dataPayload.put("id", map.get("id") != null ? map.get("id") : "");
        int typeInt = map.containsKey("type") && map.get("type") instanceof Number
                ? ((Number) map.get("type")).intValue() : 0;
        dataPayload.put("format", mimeTypeFromOfferType(typeInt));
        dataPayload.put("content", map.get("content") != null ? map.get("content") : "");
        if (map.get("language") instanceof List) {
            dataPayload.put("language", map.get("language"));
        }
        if (map.get("characteristics") instanceof Map) {
            dataPayload.put("characteristics", map.get("characteristics"));
        }
        offerItemData.put("data", dataPayload);

        if (map.get("meta") instanceof Map) {
            offerItemData.put("meta", map.get("meta"));
        }

        List<Map<String, Object>> items = new ArrayList<>();
        items.add(offerItemData);

        Map<String, Object> propositionData = new HashMap<>();
        propositionData.put("id", propositionId != null ? propositionId : "");
        propositionData.put("scope", propositionScope != null ? propositionScope : "");
        propositionData.put("scopeDetails", scopeDetails != null ? scopeDetails : new HashMap<>());
        propositionData.put("activity", activity != null ? activity : new HashMap<>());
        propositionData.put("placement", placement != null ? placement : new HashMap<>());
        propositionData.put("items", items);

        return OptimizeProposition.fromEventData(propositionData);
    }

    static String mimeTypeFromOfferType(int typeValue) {
        switch (typeValue) {
            case 1: return "application/json";
            case 2: return "text/plain";
            case 3: return "text/html";
            case 4: return "image/*";
            default: return "";
        }
    }

    @SuppressWarnings("unchecked")
    static OptimizeProposition propositionFromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }

        return OptimizeProposition.fromEventData(map);
    }

    static int offerTypeToInt(OfferType type) {
        if (type == null) return 0;
        switch (type) {
            case JSON: return 1;
            case TEXT: return 2;
            case HTML: return 3;
            case IMAGE: return 4;
            default: return 0;
        }
    }

    private static String getNullableString(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof String) ? (String) data.get(key) : null;
    }

    @SuppressWarnings("unchecked")
    private static Map<String, Object> getNullableMap(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof Map) ? (Map<String, Object>) data.get(key) : null;
    }
}
