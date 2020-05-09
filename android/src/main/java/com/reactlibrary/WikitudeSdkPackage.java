package com.reactlibrary;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.facebook.react.bridge.JavaScriptModule;

public class WikitudeSdkPackage implements ReactPackage {

    private Activity mActivity = null;
    private WikitudeViewManager wikManager;
    
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new WikitudeModule(reactContext,singleViewManager(reactContext)));
        return modules;
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
            singleViewManager(reactContext)
        );
    }

    public WikitudeViewManager singleViewManager(ReactApplicationContext context) {
        if(wikManager == null){
          Log.d("WikitudePackage","wikiManager is null");
          wikManager = new WikitudeViewManager(context);
        }else{
          Log.d("WikitudePackage","returning the same WikiManager");
        }
    
    
        return wikManager;
      }
}
