/// Configuration options for initializing the Adobe Mobile SDK.
class InitOptions {
  /// The App ID for the Adobe SDK configuration.
  String? appId;

  /// Flag indicating whether automatic lifecycle tracking is enabled
  bool? lifecycleAutomaticTrackingEnabled;

  /// Additional context data to be included in lifecycle start event.
  Map<String, String>? lifecycleAdditionalContextData;

  /// App group used to share user defaults and files among containing app and extension apps on iOS
  String? appGroup;

  /// Constructor with named optional parameters.
  InitOptions({
    this.appId,
    this.lifecycleAutomaticTrackingEnabled = null,
    this.lifecycleAdditionalContextData = null,
    this.appGroupIOS = null,
  });

  /// Converts the [InitOptions] instance to a [Map].
  Map<String, dynamic> toMap() {
    Map<String, dynamic> retMap = {};
    retMap['appId'] = appId;
    retMap['lifecycleAutomaticTrackingEnabled'] =
        lifecycleAutomaticTrackingEnabled;
    retMap['lifecycleAdditionalContextData'] = lifecycleAdditionalContextData;
    retMap['appGroup'] = appGroupIOS;

    return retMap;
  }
}
