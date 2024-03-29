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

//import 'dart:html';

import 'package:flutter_aepedgeidentity/src/aepedgeidentity_authenticated_state.dart';

///IdentityItem defines an identity to be included in an IdentityMap

class IdentityItem {
  String _id = '';
  AuthenticatedState _authenticatedState = AuthenticatedState.AMBIGUOUS;
  bool _primary = false;

  IdentityItem(final String id,
      [final AuthenticatedState authenticatedState =
          AuthenticatedState.AMBIGUOUS,
      final bool primary = false]) {
    this._id = id;
    this._authenticatedState = authenticatedState;
    this._primary = primary;
  }

  //clone for a deep copy
  factory IdentityItem.clone(IdentityItem source) {
    return IdentityItem(source.id, source.authenticatedState, source.primary);
  }

  String get id => _id;

  AuthenticatedState get authenticatedState => _authenticatedState;

  bool get primary => _primary;

  ///Convert to String
  @override
  String toString() {
    return '{id: $id, authenticatedState: $authenticatedState, primary: $primary}';
  }

  //convert to map
  Map toMap() {
    Map<String, Object> retMap = {};
    retMap['id'] = id;
    retMap['authenticatedState'] = authenticatedState.value;
    retMap['primary'] = primary;

    return retMap;
  }
}
