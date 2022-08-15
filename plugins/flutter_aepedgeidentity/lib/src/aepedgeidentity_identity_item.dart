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

import 'package:flutter_aepedgeidentity/src/aepedgeidentity_authenticated_state.dart';

///IdentityItem defines an identity to be included in an IdentityMap

class IdentityItem {
  String _id = '';
  AuthenticatedState _authenticatedState = AuthenticatedState.AMBIGOUS;
  bool _primary = false;

  IdentityItem(final String id, final AuthenticatedState authenticatedState,
      final bool primary) {
    this._id = id;
    this._authenticatedState = authenticatedState;
    this._primary = primary;
  }

  String get id => _id;

  // ///
  AuthenticatedState get authenticatedState => _authenticatedState;

  // ///
  bool get primary => _primary;

  ///Print the instance to String
  @override
  String toString() {
    return '{id: $id, authenticatedState: $authenticatedState, primary: $primary}';
  }
}
