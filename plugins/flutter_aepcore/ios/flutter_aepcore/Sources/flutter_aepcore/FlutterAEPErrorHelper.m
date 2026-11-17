#import "FlutterAEPErrorHelper.h"

@implementation FlutterAEPErrorHelper

+ (void)handleResult:(FlutterResult)result error:(NSError * _Nullable)error success:(id _Nullable)success {
    if (error) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long)error.code]
                                   message:error.localizedDescription
                                   details:nil]);
    } else {
        result(success);
    }
}

@end
