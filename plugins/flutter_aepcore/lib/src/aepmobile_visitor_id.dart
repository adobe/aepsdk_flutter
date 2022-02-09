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
enum AEPMobileVisitorAuthState { authenticated, logged_out, unknown }

extension AEPMobileVisitorAuthStateExt
    on AEPMobileVisitorAuthState {
  String get value {
    switch (this) {
      case AEPMobileVisitorAuthState.logged_out:
        return 'AEP_VISITOR_AUTH_STATE_LOGGED_OUT';
      case AEPMobileVisitorAuthState.authenticated:
        return 'AEP_VISITOR_AUTH_STATE_AUTHENTICATED';
      case AEPMobileVisitorAuthState.unknown:
        return 'AEP_VISITOR_AUTH_STATE_UNKNOWN';
    }
  }
}

extension AEPMobileVisitorAuthStateValueExt on String {
  AEPMobileVisitorAuthState
      get toAEPMobileVisitorAuthState {
    switch (this) {
      case 'AEP_VISITOR_AUTH_STATE_AUTHENTICATED':
        return AEPMobileVisitorAuthState.authenticated;
      case 'AEP_VISITOR_AUTH_STATE_LOGGED_OUT':
        return AEPMobileVisitorAuthState.logged_out;
      case 'AEP_VISITOR_AUTH_STATE_UNKNOWN':
        return AEPMobileVisitorAuthState.unknown;
    }
    throw Exception('Invalid AEPMobileVisitorAuthenticationState value: $this');
  }
}

/// This is an identifier to be used with the Experience Cloud Visitor ID Service and it contains the origin, the identifier type, the identifier,, and the authentication state of the visitor ID.
class AEPMobileVisitorId {
  final Map<dynamic, dynamic> _data;

  AEPMobileVisitorId(this._data);

  String get idOrigin => _data['idOrigin'];

  String get idType => _data['idType'];

  String get identifier => _data['identifier'];

  AEPMobileVisitorAuthState get authenticationState =>
      (_data['authenticationState'] as String)
          .toAEPMobileVisitorAuthState;

  @override
  String toString() => '$runtimeType($_data)';
}
