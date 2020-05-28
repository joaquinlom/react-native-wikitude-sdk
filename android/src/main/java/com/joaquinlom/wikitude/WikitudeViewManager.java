package com.joaquinlom.wikitude;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.support.constraint.ConstraintLayout;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.views.image.ReactImageView;
import com.wikitude.architect.ArchitectJavaScriptInterfaceListener;
import com.wikitude.architect.ArchitectStartupConfiguration;
import com.wikitude.architect.ArchitectView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

public class WikitudeViewManager extends ViewGroupManager<WikitudeView> implements ArchitectJavaScriptInterfaceListener, ArchitectView.ArchitectWorldLoadedListener {


    //Commands
    public static final int COMMAND_SET_URL = 1;
    public static final int COMMAND_CALL_JAVASCRIPT = 2;
    public static final int COMMAND_INJECT_LOCATION = 3;
    public static final int COMMAND_STOP_AR = 4;
    public static final int COMMAND_RESUME_AR = 5;
    //public static final int COMMAND_GET_ANNOTATIONS = 4;

    WikitudeView wikitude;
    ArchitectView architectView;
    ReactContext ctx;
    String licenseKey = "";
    String url = "";
    Activity activity;
    ConstraintLayout container;
    Boolean firstTime = true;
    Boolean hasCameraPermission = false;
    private final String TAG ="WikitudeViewManager";
     final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
            if(requestCode == 13){
            }
        }
    };

    final LifecycleEventListener mLifeEventListener = new LifecycleEventListener() {

        @Override
        public void onHostResume() {
            if(wikitude != null){
                Log.d(TAG,"onResume Wikitude");
                wikitude.onResume();
                firstTime = false;
            }
        }

        @Override
        public void onHostPause() {
            Log.d(TAG,"onPause");
            if(wikitude != null)
            {
                wikitude.onPause();
            }

        }

        @Override
        public void onHostDestroy() {
            Log.d(TAG,"onDestroy");
            if(wikitude != null){
               wikitude.clearCache();
               wikitude.onDestroy();
            }

        }
    };
    public WikitudeViewManager(ReactApplicationContext context){
        super();
        this.ctx = context;
    }

    public static final String REACT_CLASS = "RNWikitude";

    public void setActivity(Activity activity){
        this.activity = activity;
        //wikitude = new WikitudeView(this.activity,this.ctx,this.licenseKey);
    }
    @Override
    public String getName() {
      return REACT_CLASS;
    }
    @Override
    public WikitudeView createViewInstance(ThemedReactContext context) {

        this.activity  = context.getCurrentActivity();
        wikitude = new WikitudeView(activity,context,this.licenseKey);
        this.ctx = context;
        architectView = wikitude;
        architectView.addArchitectJavaScriptInterfaceListener(this);
        architectView.registerWorldLoadedListener(this);

        context.addActivityEventListener(mActivityEventListener);
        context.addLifecycleEventListener(mLifeEventListener);

        /*
        this.container = new ConstraintLayout(context);
        this.container.addView(wikitude);*/
       // return this.container;
        return wikitude;
    }

    @Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        Map<String, Integer> commandMap = MapBuilder.of(
                "setUrlMode",
                COMMAND_SET_URL,
                "callJSMode",
                COMMAND_CALL_JAVASCRIPT,
                "injectLocationMode",
                COMMAND_INJECT_LOCATION,
                "stopARMode",
                COMMAND_STOP_AR,
                "resumeARMode",
                COMMAND_RESUME_AR);
        return commandMap;
    }
    public WikitudeView getWikitudeView(){
        return this.wikitude;
    }

    public void setUrl(String url){
        if(this.wikitude != null){
            if(this.activity != null ){
                wikitude.setUrl(url);
                Handler mainHandler = new Handler(this.activity.getMainLooper());
                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {
                            Log.d(TAG,"Changge url");
                            wikitude.loadWorld();
                    } // This is your code
                };
                mainHandler.post(myRunnable);
            }
            
        }
    }

    public void setLocation(Double lat,Double lng){
        if(this.wikitude != null){
            if(this.activity != null ){
                wikitude.setLat(lat);
                wikitude.setLng(lng);
                Handler mainHandler = new Handler(this.activity.getMainLooper());
    
                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {
    
    
                            Log.d(TAG,"Change location");
                            wikitude.updateLocation();
    
    
                    } // This is your code
                };
                mainHandler.post(myRunnable);
            }
            
        }
    }

    public void callJavascript(String s){
        if(this.wikitude != null){
            if(this.activity != null ){
                wikitude.setJS(s);
                Handler mainHandler = new Handler(this.activity.getMainLooper());
                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {
    
    
                            Log.d(TAG,"Call JS");
                            wikitude.callJS();
    
    
                    } // This is your code
                };
                mainHandler.post(myRunnable);
            }
            
        }
    }
    @ReactProp(name = "url")
    public void setUrl(WikitudeView view, String url) {
      Log.d(TAG,"Setting url:"+url);
      this.url = url;
      this.wikitude.setUrl(url);
    }

    @ReactProp(name = "licenseKey")
    public void setLicenseKey(WikitudeView view,String licenseKey) {
        Log.d(TAG,"Setting License"+licenseKey);
        //this.wikitude.setLicenseKey(licenseKey);
        view.setLicenseKey(licenseKey);
        // startUpConfig.setLicenseKey( this.licenseKey);
    }

    public void resumeAR(){
        /*if(wikitude != null){
            Thread webThread = getThreadByName("mqt_native_modules");
            if(webThread != null){
                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {
                        wikitude.onResume();
                    } // This is your code
                };
                //webThread.post(webThread);
            }
        }*/
        if(this.activity != null ){
            Handler mainHandler = new Handler(this.activity.getMainLooper());

            Runnable myRunnable = new Runnable() {
                @Override
                public void run() {
                        wikitude.clearCache();
                        wikitude.loadWorld();
                        Log.d(TAG,"On resume en handler");
                        wikitude.onResume();


                } // This is your code
            };
            mainHandler.post(myRunnable);
        }

    }
    public Thread getThreadByName(String threadName) {
        for (Thread t : Thread.getAllStackTraces().keySet()) {
            if (t.getName().equals(threadName)) return t;
        }
        return null;
    }
    public void stopAR(){
        if(wikitude != null){
            if(this.activity != null ){
                Handler mainHandler = new Handler(this.activity.getMainLooper());

                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {


                        Log.d(TAG,"OnPause en handler");
                        wikitude.clearCache();
                        wikitude.onPause();


                    } // This is your code
                };
                mainHandler.post(myRunnable);
            }
        }
    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        "onJsonReceived",
                        MapBuilder.of(
                                "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onJsonReceived")))
                .put(
                "onFinishLoading",
                         MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onFinishLoading"))).
                 put(
                     "onFailLoading",
                         MapBuilder.of(
                                 "phasedRegistrationNames",
                         MapBuilder.of("bubbled", "onFailLoading")))
                .build();
    }
    @Override
    public void onJSONObjectReceived(JSONObject jsonObject) {
        Log.d("Wikitude onJsonReceived","jsonObject receive");
        WritableMap event = Arguments.createMap();

        Iterator<String> keys = jsonObject.keys();

        while(keys.hasNext()) {
            String key = keys.next();
            String value = null;
            try {
                value = (String)jsonObject.get(key);
                event.putString(key,value);
            } catch (JSONException e) {
                e.printStackTrace();
            }

        }

        ReactContext reactContext = this.ctx;
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                this.wikitude.getId(),
                "onJsonReceived",
                event);
    }

    @Override
    public void worldWasLoaded(String s) {
        WritableMap event = Arguments.createMap();
        event.putString("message",s);
        ReactContext reactContext = this.ctx;
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                this.wikitude.getId(),
                "onFinishLoading",
                event);
    }

    @Override
    public void worldLoadFailed(int i, String s, String s1) {
        WritableMap event = Arguments.createMap();
        event.putString("message",s);
        ReactContext reactContext = this.ctx;
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                wikitude.getId(),
                "onFailLoading",
                event);
    }

    //Commands methds

    @Override
    public void receiveCommand(WikitudeView root, int commandId, @javax.annotation.Nullable ReadableArray args) {
        //super.receiveCommand(root, commandId, args);
        switch (commandId){
            case COMMAND_SET_URL:
                try {
                    String url = args.getString(0);

                    if(!url.isEmpty())
                        root.load(url);
                } catch (IOException e) {
                    Log.d(TAG,e.getMessage());
                }
                break;
            case COMMAND_CALL_JAVASCRIPT:
                root.callJavascript(args.getString(0));
                break;
            case COMMAND_INJECT_LOCATION:
                root.setLocation(args.getDouble(0),args.getDouble(0),100f);
                break;
            case COMMAND_RESUME_AR:
                //without thread handling
                //root.onResume();
                resumeAR();
                break;
            case COMMAND_STOP_AR:
                //root.onPause();
                stopAR();
                break;
        }
    }
}

class WikitudeView extends ArchitectView{

    Context ctx;
    Activity activity;
    String licenseKey = "";
    String url = "";
    String javascript = "";
    Double lat = 0.0;
    Double lng = 0.0;

    public void setLat(Double lat){
        this.lat = lat;
    }
    public void setLng(Double lng){
        this.lng = lng;
    }
    public void updateLocation(){
        this.setLocation(this.lat,this.lng,100f);
    }
    private ArchitectStartupConfiguration startUpConfig = new ArchitectStartupConfiguration();

    public WikitudeView(Activity activity){
        super(activity);
    }
    public WikitudeView(Activity activity,Context ctx,String licenseKey){
        super(activity);
        this.activity = activity;
        this.licenseKey = licenseKey;
    }

    public void createWikitude(){
        this.onCreate(startUpConfig);
        this.onPostCreate();
        try{
            Log.d("Loading World",this.url);
            this.load(this.url);
        }catch (IOException e){

        }
    }

    public void setUrl(String newUrl){
        this.url = newUrl;
    }
    public void setLicenseKey(String license){
        startUpConfig.setLicenseKey( license );
        createWikitude();
    }

    public void loadWorld(){
        try{
            Log.d("WikitudeView",this.url);
            this.load(this.url);
        }catch(IOException e){
            Log.e("WikitudeView",e.getMessage());
        }
    }
    public void setJS(String s){
        this.javascript = s;
    }
    public void callJS(){
        this.callJavascript(this.javascript);
    }
}

