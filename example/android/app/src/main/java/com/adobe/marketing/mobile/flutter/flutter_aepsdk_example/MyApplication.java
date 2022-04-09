package com.adobe.marketing.mobile.flutter.flutter_aepsdk_example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.adobe.marketing.mobile.*;

import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        MobileCore.setApplication(this);
        MobileCore.setLogLevel(LoggingMode.VERBOSE);
        MobileCore.setWrapperType(WrapperType.FLUTTER);
        
        try {
            Identity.registerExtension();
            Lifecycle.registerExtension();
            Signal.registerExtension();
            Assurance.registerExtension();
            Edge.registerExtension();
            MobileCore.start(o -> MobileCore.configureWithAppID("yourAppId"));
        } catch (InvalidInitException e) {
            Log.e("MyApplication", String.format("Error while registering extensions %s", e.getLocalizedMessage()));
        }

        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle bundle) { /*no-op*/ }

            @Override
            public void onActivityStarted(Activity activity) { /*no-op*/ }

            @Override
            public void onActivityResumed(Activity activity) {
                MobileCore.setApplication(MyApplication.this);
                MobileCore.lifecycleStart(null);
            }

            @Override
            public void onActivityPaused(Activity activity) {
                MobileCore.lifecyclePause();
            }

            @Override
            public void onActivityStopped(Activity activity) { /*no-op*/ }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle bundle) { /*no-op*/ }

            @Override
            public void onActivityDestroyed(Activity activity) { /*no-op*/ }
        });

    }
}
