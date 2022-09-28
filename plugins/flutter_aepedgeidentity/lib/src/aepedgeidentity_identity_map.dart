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

import 'dart:async';
import 'package:flutter_aepedgeidentity/src/aepedgeidentity_identity_item.dart';

/// identity map containing a set of end user identities, keyed on either namespace integration code or the namespace ID of the identity.
/// TO DO: Trying to converting identityMap to Json.

class IdentityMap {
  ///add an `IdentityItem` to this `IdentityMap`
  Map<String, List<IdentityItem>> identityMap = {};
  Map<String, Map<String, List<Map<dynamic, dynamic>>>> retidentityMap = {};

  void addItem(IdentityItem item, String namespace) {
    if (item.id.isEmpty || item.id.length == 0) {
      return;
    }

    ///add item to the existing namespace
    ///

    IdentityItem itemCopy = copyItem(item);

    if (this.identityMap[namespace] != null) {
      int index = this
          .identityMap[namespace]!
          .indexWhere((element) => equalIds(element.id, itemCopy.id));
      if (index != -1) {
        this.identityMap[namespace]![index] = itemCopy;
      } else
        [this.identityMap[namespace]!.add(itemCopy)];
    } else {
      this.identityMap[namespace] = [itemCopy];
    }
  }

  /// Checks if this `IdentityMap` is empty
  bool isEmpty() {
    return this.identityMap.keys.toList().isEmpty;
  }

  /// Gets a list of all namespaces available in this `IdentityMap`
  List<dynamic> getNamespaces() {
    return this.identityMap.keys.toList();
  }

  /// Retrieves the IdentityItems for a given namespace
  List<IdentityItem>? getIdentityItemsForNamespace(String namespace) {
    return this.identityMap[namespace];
  }

  /// Removes the provided `IdentityItem` for a namespace from the `IdentityMap`
  void removeItem(IdentityItem item, String namespace) {
    if (item.id.isEmpty || item.id.length == 0) {
      return;
    }

    /// remove item from the existing namespace
    if (this.identityMap[namespace] != null) {
      List<IdentityItem> list = this
          .identityMap[namespace]!
          .where((element) => equalIds(element.id, element.id))
          .toList();
      if (list.length == 0) {
        this
            .identityMap
            .removeWhere((key, value) => key == this.identityMap[namespace]);
      } else
        this.identityMap[namespace] = list;
    }
  }

  ///Be able to print the instance to String
  @override
  String toString() {
    return '{identityMap: $identityMap}';
  }

  IdentityItem copyItem(IdentityItem item) {
    IdentityItem clonedItem =
        new IdentityItem(item.id, item.authenticatedState, item.primary);
    return clonedItem;
  }

  bool equalIds(String id1, String id2) {
    return id1.toLowerCase() == id2.toLowerCase();
  }

  Map toMap() {
    Map<String, List<Map<dynamic, dynamic>>> retMap = {};

    identityMap.forEach((key, value) {
      print(key);
      print(value);

      List<Map<dynamic, dynamic>> convertedIdItemList = [];
      value.forEach((v) {
        Map<dynamic, dynamic> newvalue = v.toMap();
        convertedIdItemList.add(newvalue);
      });

      retMap = {key: convertedIdItemList};
    });

    return retMap;
  }
}
