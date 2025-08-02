//file path: android/whopreactnativekit/src/main/java/com/whoprnkit/whopreactnativekit/ReactNativeHostManager.java

package com.whoprnkit.whopreactnativekit; // If you used a different package name when creating the library, change it here

import android.app.Application;
import com.callstack.reactnativebrownfield.OnJSBundleLoaded;
import com.callstack.reactnativebrownfield.ReactNativeBrownfield;
import com.facebook.react.PackageList;
import com.facebook.react.ReactPackage;
import static com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative;

import java.util.List;

public class ReactNativeHostManager {
  public static List<ReactPackage> getPackages(Application application) {
    List<ReactPackage> packages = new PackageList(application).getPackages();
    return packages;
  }

  

    /**
     * Initialize React Native without a JS bundle callback.
     */
    public static void initialize(Application application) {
        initialize(application, null);
    }

    /**
     * Initialize React Native and Brownfield integration.
     *
     * @param application       your Application instance
     * @param onJSBundleLoaded  optional callback invoked when the JS bundle has finished loading
     */
    public static void initialize(Application application, OnJSBundleLoaded onJSBundleLoaded) {
        // Only required if you're on RN version >= 0.80.0
        loadReactNative(application);

        // Get the list of ReactPackages
        List<ReactPackage> packages = new PackageList(application).getPackages();

        // Initialize the Brownfield module
        ReactNativeBrownfield.initialize(application, packages, onJSBundleLoaded);
    }
}