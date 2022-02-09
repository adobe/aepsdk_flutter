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

// This class is used to set the log level

enum AEPLogLevel { error, warning, debug, trace }

extension AEPLogLevelExt on AEPLogLevel {
  String get value {
    switch (this) {
      case AEPLogLevel.error:
        return 'AEP_LOG_LEVEL_ERROR';
      case AEPLogLevel.warning:
        return 'AEP_LOG_LEVEL_WARNING';
      case AEPLogLevel.debug:
        return 'AEP_LOG_LEVEL_DEBUG';
      case AEPLogLevel.trace:
        return 'AEP_LOG_LEVEL_VERBOSE';
    }
  }
}

extension AEPLogLevelValueExt on String {
  AEPLogLevel get toAEPLogLevel {
    switch (this) {
      case 'AEP_LOG_LEVEL_ERROR':
        return AEPLogLevel.error;
      case 'AEP_LOG_LEVEL_WARNING':
        return AEPLogLevel.warning;
      case 'AEP_LOG_LEVEL_DEBUG':
        return AEPLogLevel.debug;
      case 'AEP_LOG_LEVEL_VERBOSE':
        return AEPLogLevel.trace;
    }
    throw Exception('Invalid AEPLogLevel value: $this');
  }
}
