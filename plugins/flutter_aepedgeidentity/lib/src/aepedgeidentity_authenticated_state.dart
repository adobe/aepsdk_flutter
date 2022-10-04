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

/// Authenticated State is a state defines for IdentityItem
///
/// The possible authenticated state are ambiguous, authenticated and loggedOut

enum AuthenticatedState { AUTHENTICATED, LOGGED_OUT, AMBIGOUS }

extension AEPAuthStateExt on AuthenticatedState {
  String get value {
    switch (this) {
      case AuthenticatedState.LOGGED_OUT:
        return 'loggedOut';
      case AuthenticatedState.AUTHENTICATED:
        return 'authenticated';
      case AuthenticatedState.AMBIGOUS:
        return 'ambiguous';
    }
  }
}

extension AEPAuthStateValueExt on String {
  AuthenticatedState get toAEPAuthState {
    switch (this) {
      case 'authenticated':
        return AuthenticatedState.AUTHENTICATED;
      case 'loggedOut':
        return AuthenticatedState.LOGGED_OUT;
      case 'ambiguous':
        return AuthenticatedState.AMBIGOUS;
    }
    return AuthenticatedState.AMBIGOUS;
  }
}
