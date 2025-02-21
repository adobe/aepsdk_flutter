#import <Flutter/Flutter.h>

@interface FlutterAEPErrorHelper : NSObject

+ (void)handleResult:(FlutterResult)result error:(NSError * _Nullable)error success:(id _Nullable)success;

@end
