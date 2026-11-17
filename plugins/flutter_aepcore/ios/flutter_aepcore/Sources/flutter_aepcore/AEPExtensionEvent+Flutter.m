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

#import "AEPExtensionEvent+Flutter.h"

@implementation AEPEvent (Flutter)

static NSString* const EVENT_NAME_KEY = @"eventName";
static NSString* const EVENT_TYPE_KEY = @"eventType";
static NSString* const EVENT_SOURCE_KEY = @"eventSource";
static NSString* const EVENT_DATA_KEY = @"eventData";

+ (AEPEvent *)eventFromDictionary: (nonnull NSDictionary *) dict {
    NSString *name = [dict objectForKey:EVENT_NAME_KEY];
    NSString *type = [dict objectForKey:EVENT_TYPE_KEY];
    NSString *source = [dict objectForKey:EVENT_SOURCE_KEY];

    if (name && type && source && ([[dict objectForKey:EVENT_DATA_KEY] isKindOfClass:[NSDictionary class]] || ![dict objectForKey:EVENT_DATA_KEY])) {
        return [[AEPEvent alloc] initWithName:name type:type source:source data:[dict objectForKey:EVENT_DATA_KEY]];
    }

    return nil;
}

+ (NSDictionary *)dictionaryFromEvent: (nonnull AEPEvent *) event {
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionary];
    eventDict[EVENT_NAME_KEY] = event.name;
    eventDict[EVENT_TYPE_KEY] = event.type;
    eventDict[EVENT_SOURCE_KEY] = event.source;
    eventDict[EVENT_DATA_KEY] = event.data;

    return eventDict;
}

@end
