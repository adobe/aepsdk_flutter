#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [self initSDK:application];

    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)initSDK:(UIApplication *) application {
    [AEPMobileCore setLogLevel:AEPLogLevelTrace];
    [AEPMobileCore setPrivacyStatus:AEPPrivacyStatusOptedIn];
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];

     // TODO: Set up the preferred Environment File ID from your mobile property configured in Data Collection UI
    NSString* ENVIRONMENT_FILE_ID = @"YOUR-APP-ID";
    
    const UIApplicationState appState = application.applicationState;

    NSArray *extensionsToRegister = @[AEPMobileIdentity.class, 
                                      AEPMobileLifecycle.class, 
                                      AEPMobileSignal.class, 
                                      AEPMobileAssurance.class, 
                                      AEPMobileEdgeConsent.class];
    
    [AEPMobileCore registerExtensions:extensionsToRegister completion:^{
        if (appState != UIApplicationStateBackground) {
            [AEPMobileCore lifecycleStart:nil];
        }
    }];
    
    [AEPMobileCore configureWithAppId: ENVIRONMENT_FILE_ID];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AEPMobileCore lifecyclePause];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [AEPMobileCore lifecycleStart:nil];
}

@end
