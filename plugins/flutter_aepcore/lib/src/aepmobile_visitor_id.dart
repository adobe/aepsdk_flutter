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

/// This is used to indicate the authentication state for the current AEPMobileVisitorId
///
enum MobileVisitorAuthenticationState { authenticated, logged_out, unknown }

extension AEPMobileVisitorAuthStateExt
    on MobileVisitorAuthenticationState {
  String get value {
    switch (this) {
      case MobileVisitorAuthenticationState.logged_out:
        return 'AEP_VISITOR_AUTH_STATE_LOGGED_OUT';
      case MobileVisitorAuthenticationState.authenticated:
        return 'AEP_VISITOR_AUTH_STATE_AUTHENTICATED';
      case MobileVisitorAuthenticationState.unknown:
        return 'AEP_VISITOR_AUTH_STATE_UNKNOWN';
    }
  }
}

extension AEPMobileVisitorAuthStateValueExt on String {
  MobileVisitorAuthenticationState
      get toAEPMobileVisitorAuthState {
    switch (this) {
      case 'AEP_VISITOR_AUTH_STATE_AUTHENTICATED':
        return MobileVisitorAuthenticationState.authenticated;
      case 'AEP_VISITOR_AUTH_STATE_LOGGED_OUT':
        return MobileVisitorAuthenticationState.logged_out;
      case 'AEP_VISITOR_AUTH_STATE_UNKNOWN':
        return MobileVisitorAuthenticationState.unknown;
    }
    throw Exception('Invalid AEPMobileVisitorAuthenticationState value: $this');
  }
}

/// This is an identifier to be used with the Experience Cloud Visitor ID Service and it contains the origin, the identifier type, the identifier,, and the authentication state of the visitor ID.
class Identifiable {
  final Map<dynamic, dynamic> _data;

  Identifiable(this._data);

  String get idOrigin => _data['idOrigin'];

  String get idType => _data['idType'];

  String get identifier => _data['identifier'];

  MobileVisitorAuthenticationState get authenticationState =>
      (_data['authenticationState'] as String)
          .toAEPMobileVisitorAuthState;

  @override
  String toString() => '$runtimeType($_data)';
}
