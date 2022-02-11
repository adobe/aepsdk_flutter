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

// This class is used to set the privacy status
enum PrivacyStatus { opt_in, opt_out, unknown }

extension AEPPrivacyStatusExt on PrivacyStatus {
  String get value {
    switch (this) {
      case PrivacyStatus.opt_in:
        return 'AEP_PRIVACY_STATUS_OPT_IN';
      case PrivacyStatus.opt_out:
        return 'AEP_PRIVACY_STATUS_OPT_OUT';
      case PrivacyStatus.unknown:
        return 'AEP_PRIVACY_STATUS_UNKNOWN';
    }
  }
}

extension AEPPrivacyStatusValueExt on String {
  PrivacyStatus get toAEPPrivacyStatus {
    switch (this) {
      case 'AEP_PRIVACY_STATUS_OPT_IN':
        return PrivacyStatus.opt_in;
      case 'AEP_PRIVACY_STATUS_OPT_OUT':
        return PrivacyStatus.opt_out;
      case 'AEP_PRIVACY_STATUS_UNKNOWN':
        return PrivacyStatus.unknown;
    }
    throw Exception('Invalid AEPPrivacyStatus value: $this');
  }
}
