#import "FlutterAEPMessagingPlugin.h"
#if __has_include(<flutter_aepmessaging/flutter_aepmessaging-Swift.h>)
#import <flutter_aepmessaging/flutter_aepmessaging-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_aepmessaging-Swift.h"
#endif

@implementation FlutterAEPMessagingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [SwiftFlutterAEPMessagingPlugin registerWithRegistrar:registrar];
}
@end