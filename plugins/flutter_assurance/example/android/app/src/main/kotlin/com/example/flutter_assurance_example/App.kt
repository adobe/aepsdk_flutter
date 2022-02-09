package com.example.flutter_assurance_example


import android.util.Log
import com.adobe.marketing.mobile.*
import io.flutter.app.FlutterApplication


class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        MobileCore.setApplication(this);
        MobileCore.setLogLevel(LoggingMode.VERBOSE);
        MobileCore.setWrapperType(WrapperType.FLUTTER);

        try {
            Identity.registerExtension()
            Lifecycle.registerExtension()
            Signal.registerExtension()
            Assurance.registerExtension()
            MobileCore.start { o: Any? -> MobileCore.configureWithAppID("yourAppId") }
        } catch (e: InvalidInitException) {
            Log.e( "MyApplication",
                String.format("Error while registering extensions %s", e.localizedMessage))
        }
    }
}
