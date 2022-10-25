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

import 'package:flutter_aepedgeidentity/src/aepedgeidentity_identity_item.dart';

/// identity map containing a set of end user identities, keyed on either namespace integration code or the namespace ID of the identity.

class IdentityMap {
  Map<String, List<IdentityItem>> identityMap = {};

  ///add an `IdentityItem` to this `IdentityMap`
  void addItem(IdentityItem item, String namespace) {
    if (item.id.isEmpty) {
      return;
    }

    ///add item to the existing namespace
    IdentityItem itemCopy = _copyItem(item);

    if (this.identityMap[namespace] != null) {
      int index = this
          .identityMap[namespace]!
          .indexWhere((element) => _equalIds(element.id, itemCopy.id));
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
  List<IdentityItem> getIdentityItemsForNamespace(String namespace) {
    if (!this.identityMap.containsKey(namespace)) {
      return List.empty();
    }

    List<IdentityItem> itemsFromNamespaceCopy = this
        .identityMap[namespace]!
        .map((items) => IdentityItem.clone(items))
        .toList();

    return itemsFromNamespaceCopy;
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
          .where((element) => !_equalIds(element.id, item.id))
          .toList();
      if (list.length == 0) {
        this.identityMap.remove(namespace);
      } else
        this.identityMap[namespace] = list;
    }
  }

  ///Convert to String
  @override
  String toString() {
    return '{identityMap: $identityMap}';
  }

  IdentityItem _copyItem(IdentityItem item) {
    IdentityItem clonedItem =
        new IdentityItem(item.id, item.authenticatedState, item.primary);
    return clonedItem;
  }

  bool _equalIds(String id1, String id2) {
    return id1.toLowerCase() == id2.toLowerCase();
  }

  ///Convert to Map
  Map toMap() {
    Map retMapAll = {};

    Map<String, List<Map<dynamic, dynamic>>> retMap = {};

    identityMap.forEach((key, value) {
      List<Map<dynamic, dynamic>> convertedIdItemList = [];

      value.forEach((v) {
        Map<dynamic, dynamic> value = v.toMap();
        convertedIdItemList.add(value);
      });

      retMap[key] = convertedIdItemList;
    });

    retMapAll = {'identityMap': retMap};
    return retMapAll;
  }
}
