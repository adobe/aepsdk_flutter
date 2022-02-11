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

enum LogLevel { error, warning, debug, trace }

extension AEPLogLevelExt on LogLevel {
  String get value {
    switch (this) {
      case LogLevel.error:
        return 'AEP_LOG_LEVEL_ERROR';
      case LogLevel.warning:
        return 'AEP_LOG_LEVEL_WARNING';
      case LogLevel.debug:
        return 'AEP_LOG_LEVEL_DEBUG';
      case LogLevel.trace:
        return 'AEP_LOG_LEVEL_VERBOSE';
    }
  }
}

extension AEPLogLevelValueExt on String {
  LogLevel get toAEPLogLevel {
    switch (this) {
      case 'AEP_LOG_LEVEL_ERROR':
        return LogLevel.error;
      case 'AEP_LOG_LEVEL_WARNING':
        return LogLevel.warning;
      case 'AEP_LOG_LEVEL_DEBUG':
        return LogLevel.debug;
      case 'AEP_LOG_LEVEL_VERBOSE':
        return LogLevel.trace;
    }
    throw Exception('Invalid AEPLogLevel value: $this');
  }
}
