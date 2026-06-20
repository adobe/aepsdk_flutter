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

        List<Map<String, Object>> offersArray = new ArrayList<>();
        if (proposition.getOffers() != null) {
            for (Offer offer : proposition.getOffers()) {
                offersArray.add(mapFromOffer(offer));
            }
        }
        map.put("offers", offersArray);
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
    static Offer offerFromMap(Map<String, Object> map) {
        if (map == null) {
            return null;
        }

        String id = getNullableString(map, "id");
        int typeInt = map.containsKey("type") && map.get("type") instanceof Number
                ? ((Number) map.get("type")).intValue() : 0;
        String content = getNullableString(map, "content");

        Offer.Builder builder = new Offer.Builder(
                id != null ? id : "",
                intToOfferType(typeInt),
                content != null ? content : "");

        String etag = getNullableString(map, "etag");
        if (etag != null) {
            builder.setEtag(etag);
        }

        if (map.containsKey("score") && map.get("score") instanceof Number) {
            builder.setScore(((Number) map.get("score")).doubleValue());
        }

        String schema = getNullableString(map, "schema");
        if (schema != null) {
            builder.setSchema(schema);
        }

        Map<String, Object> meta = getNullableMap(map, "meta");
        if (meta != null) {
            builder.setMeta(meta);
        }

        List<String> language = (List<String>) map.get("language");
        if (language != null) {
            builder.setLanguage(language);
        }

        Map<String, String> characteristics = map.containsKey("characteristics") && map.get("characteristics") instanceof Map
                ? (Map<String, String>) map.get("characteristics") : null;
        if (characteristics != null) {
            builder.setCharacteristics(characteristics);
        }

        return builder.build();
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

    static OfferType intToOfferType(int value) {
        switch (value) {
            case 1: return OfferType.JSON;
            case 2: return OfferType.TEXT;
            case 3: return OfferType.HTML;
            case 4: return OfferType.IMAGE;
            default: return OfferType.UNKNOWN;
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
