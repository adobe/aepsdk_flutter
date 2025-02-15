/// Configuration options for initializing the Adobe Mobile SDK.
class InitOptions {
  /// The App ID for the Adobe SDK configuration.
  String? appId;
  /// The file path for the local configuration file
  String? filePath;
  /// Flag indicating whether automatic lifecycle tracking is enabled
  bool? lifecycleAutomaticTracking;
  /// Additional context data to be included in lifecycle start event.
  Map<String, String>? lifecycleAdditionalContextData;
  /// App group used to share user defaults and files among containing app and extension apps on iOS
  String? appGroupIOS;

  /// Constructor with named optional parameters.
  /// 
  /// Asserts that both `appId` and `filePath` are not set at the same time.
  InitOptions({
    this.appId,
    this.filePath,
    this.lifecycleAutomaticTracking = true,
    this.lifecycleAdditionalContextData = null, 
    this.appGroupIOS = null,
  }) : assert(!(appId != null && filePath != null),
            'Both appId and filePath cannot be set at the same time');

  /// Converts the [InitOptions] instance to a [Map].
  Map<String, dynamic> toMap() {
    Map<String, dynamic> retMap = {};
    retMap['appId'] = appId;
    retMap['filePath'] = filePath;
    retMap['lifecycleAutomaticTracking'] = lifecycleAutomaticTracking;
    retMap['lifecycleAdditionalContextData'] = lifecycleAdditionalContextData;
    retMap['appGroupIOS'] = appGroupIOS;

    return retMap;
  }
}
