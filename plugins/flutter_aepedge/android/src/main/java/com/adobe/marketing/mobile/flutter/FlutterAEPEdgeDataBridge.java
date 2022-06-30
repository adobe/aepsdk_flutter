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

package com.adobe.marketing.mobile.flutter;

import com.adobe.marketing.mobile.EdgeEventHandle;
import com.adobe.marketing.mobile.ExperienceEvent;


import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;


public class FlutterAEPEdgeDataBridge {

    // Event Object Keys
    public final static String XDM_DATA_KEY = "xdmData";
    public final static String DATA_KEY = "data";
    public final static String DATASET_IDENTIFIER_KEY = "datasetIdentifier";
    public final static String TYPE_KEY = "type";
    public final static String PAYLOAD_KEY = "payload";

    /**
     * Converts a {@link Map} into an {@link ExperienceEvent}
     *
     * @param map
     * @return An {@link ExperienceEvent}
     */
    static ExperienceEvent eventFromMap(final Map map) {
         if (map == null) {
             return null;
         }

        Map<String, Object> xdmdata = getNullableMap(map, XDM_DATA_KEY);
        String datasetId = null;


        if (xdmdata != null) {

            Map<String, Object> data = getNullableMap(map, DATA_KEY);

            try {
                datasetId = getNullableString(map, DATASET_IDENTIFIER_KEY);
            } catch (Exception e) {
                //Log.d(TAG, "experienceEventFromReadableMap: " + e);
            }

            ExperienceEvent event = new ExperienceEvent.Builder().setXdmSchema(xdmdata, datasetId).setData(data).build();

            return event;
        }
            return null;

    }

    /**
     * Converts a {@link  EdgeEventHandle} into a {@link Map}
     * @param eventhandle
     * @return A {@link Map} that represents the eventhandle
     */
    public static Map mapFromEdgeEventHandle(final EdgeEventHandle eventhandle) {
        if (eventhandle == null) {
            return null;
        }

        Map eventHandleMap = new HashMap();
        if (eventhandle.getType() != null) {
            eventHandleMap.put(TYPE_KEY, eventhandle.getType());
        }
        if (eventhandle.getPayload() != null) {
            Object[] handles = new Object[] {eventhandle.getPayload().size()};
            handles = eventhandle.getPayload().toArray();
            eventHandleMap.put(PAYLOAD_KEY, handles);
        }
        return eventHandleMap;
    }


    // Helper methods

    private static String getNullableString(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof String) ? (String) data.get(key) : null;
    }

    private static Map getNullableMap(final Map data, final String key) {
        return data.containsKey(key) && (data.get(key) instanceof Map) ? (Map) data.get(key) : null;
    }
}
