/*
Copyright 2026 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

enum OfferType { unknown, json, text, html, image }

extension OfferTypeExtension on OfferType {
  int get rawValue {
    switch (this) {
      case OfferType.unknown:
        return 0;
      case OfferType.json:
        return 1;
      case OfferType.text:
        return 2;
      case OfferType.html:
        return 3;
      case OfferType.image:
        return 4;
    }
  }

  String get mimeType {
    switch (this) {
      case OfferType.unknown:
        return '';
      case OfferType.json:
        return 'application/json';
      case OfferType.text:
        return 'text/plain';
      case OfferType.html:
        return 'text/html';
      case OfferType.image:
        return 'image/*';
    }
  }
}

extension OfferTypeFromInt on int {
  OfferType toOfferType() {
    switch (this) {
      case 0:
        return OfferType.unknown;
      case 1:
        return OfferType.json;
      case 2:
        return OfferType.text;
      case 3:
        return OfferType.html;
      case 4:
        return OfferType.image;
      default:
        return OfferType.unknown;
    }
  }
}
