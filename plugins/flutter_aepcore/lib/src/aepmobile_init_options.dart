class InitOptions {
  String? appId;
  String? filePath;
  bool lifecycleAutomaticTracking;
  Map<String, String>? lifecycleAdditionalContextData;
  String? appGroupIOS;

  // Constructor with named optional parameters
  InitOptions({
    this.appId,
    this.filePath,
    this.lifecycleAutomaticTracking = true, // Default value set to true
    this.lifecycleAdditionalContextData = null, // Default value set to null
    this.appGroupIOS = null, // Default value set to null
  }) : assert(appId != null || filePath != null,
            'Either appId or filePath must be provided');

  // Method to convert InitOptions to a Map
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
