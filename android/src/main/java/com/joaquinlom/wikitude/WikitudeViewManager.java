package com.joaquinlom.wikitude;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.util.Log;
import android.util.Base64;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import java.net.URL;
import java.io.ByteArrayOutputStream;
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
import com.joaquinlom.wikitude.JsonConvert;
import com.facebook.react.views.image.ReactImageView;
import com.wikitude.architect.ArchitectJavaScriptInterfaceListener;
import com.wikitude.architect.ArchitectStartupConfiguration;
import com.wikitude.architect.ArchitectView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

public class WikitudeViewManager extends ViewGroupManager<WikitudeView> implements ArchitectJavaScriptInterfaceListener, ArchitectView.ArchitectWorldLoadedListener, ArchitectView.CaptureScreenCallback {


    //Commands
    public static final int COMMAND_SET_URL = 1;
    public static final int COMMAND_CALL_JAVASCRIPT = 2;
    public static final int COMMAND_INJECT_LOCATION = 3;
    public static final int COMMAND_STOP_AR = 4;
    public static final int COMMAND_RESUME_AR = 5;
    public static final int COMMAND_CAPTURE_SCREEN = 6;
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
                wikitude.loadWorld();
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
        wikitude = new WikitudeView(activity,context,this.licenseKey,this);
        
        this.ctx = context;
        //architectView = wikitude;
        wikitude.addArchitectJavaScriptInterfaceListener(this);
        //wikitude.registerWorldLoadedListener(this);
        //wikitude.onPostCreate();
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
                COMMAND_RESUME_AR,
                "captureScreen",
                COMMAND_CAPTURE_SCREEN);
        return commandMap;
    }
    public WikitudeView getWikitudeView(){
        return this.wikitude;
    }
    public void setUrlFromModule(String url){

    }
    @ReactMethod
    public void setNewUrl(String url){
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
    

    @ReactProp(name = "feature")
    public void setFeature(WikitudeView view, int feature){

    }

    @ReactProp(name = "url")
    public void setUrl(WikitudeView view, String url) {
            Log.d(TAG,"Setting url:"+url);
            view.setUrl(url);
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
                         MapBuilder.of( "phasedRegistrationNames",MapBuilder.of("bubbled", "onFailLoading")))
                .put(
                    "onScreenCaptured",
                    MapBuilder.of("phasedRegistrationNames",MapBuilder.of("bubbled","onScreenCaptured"))
                )
                .build();
    }

    @Override
    public void onScreenCaptured(Bitmap image){
        WritableMap event = Arguments.createMap();

        //Bitmap to byte[]
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();  
        image.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream .toByteArray();
        String encoded = Base64.encodeToString(byteArray, Base64.DEFAULT);
        
        event.putString("image",encoded);
        ReactContext reactContext = this.ctx;
        Log.d(TAG,"Screenshot capture");
        //Log.d(TAG,"image "+encoded);

        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                this.wikitude.getId(),
                "onScreenCaptured",
                event);        
    }

    @Override
    public void onJSONObjectReceived(JSONObject jsonObject) {
        Log.d("Wikitude onJsonReceived","jsonObject receive");

        WritableMap map;
        try {
            map = JsonConvert.jsonToReact(jsonObject);

            ReactContext reactContext = this.ctx;
            reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                    this.wikitude.getId(),
                    "onJsonReceived",
                    map);
        }catch(org.json.JSONException ex){
            System.out.println("Exception: " + ex);
        }

        

        /*
        WritableMap event = Arguments.createMap();
        Iterator<String> keys = jsonObject.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            String value = null;
            try {
                value = (String)jsonObject.get(key);
                event.putString(key,value);
            } catch (JSONException e) {
                Log.d("Wikitude","Error en JSON");
                e.printStackTrace();
            }

        }

        ReactContext reactContext = this.ctx;
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                this.wikitude.getId(),
                "onJsonReceived",
                event);
        */
    }

    @Override
    public void worldWasLoaded(String s) {
        WritableMap event = Arguments.createMap();
        event.putString("message",s);
        ReactContext reactContext = this.ctx;
        Log.d(TAG,"World Loaded");
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                this.wikitude.getId(),
                "onFinishLoading",
                event);
    }

    @Override
    public void worldLoadFailed(int i, String s, String s1) {
        WritableMap event = Arguments.createMap();
        event.putString("message",s);
        Log.e("Wikitude",s);
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
                    /*
                    String url = args.getString(0);

                    if(!url.isEmpty())
                        root.load(url);
                        */
                    root.setUrl(args.getString(0));
                break;
            case COMMAND_CALL_JAVASCRIPT:
                root.callJavascript(args.getString(0));
                break;
            case COMMAND_INJECT_LOCATION:
                root.setLocation(args.getDouble(0),args.getDouble(1),100f);
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
            case COMMAND_CAPTURE_SCREEN:
                root.captureScreen(args.getBoolean(0));
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
    String TAG = "WikitudeView";
    WikitudeViewManager ctxManager;
    private ArchitectStartupConfiguration startUpConfig = new ArchitectStartupConfiguration();

    public WikitudeView(Activity activity){
        super(activity);
    }
    public WikitudeView(Activity activity,Context ctx,String licenseKey,WikitudeViewManager manager){
        super(activity);
        this.activity = activity;
        this.licenseKey = licenseKey;
        this.ctxManager = manager;
        Log.d(TAG,"Creating Wikitude view");
    }

    public void createWikitude(){
        this.onCreate(startUpConfig);
        this.onPostCreate();
        this.registerWorldLoadedListener(ctxManager);
        try{
            this.load(this.url);
        }catch (IOException e){
            Log.e(TAG,e.getMessage());
        }
    }

    public boolean isUrl(String url){
        try{
            new URL(url).toURI();
            return true;
        }catch(Exception e){
            return false;
        }
    }
    public void setUrl(String newUrl){
        if(isUrl(newUrl)){
            Log.d(TAG,"Es Web URL");
            this.url = newUrl;
        }else{
            Log.d(TAG,"Es local URL");
            this.url = newUrl+".html";
        }
        Log.d(TAG,"Setting URL Again");
        //this.url = newUrl;
        
        this.loadWorld();
        //createWikitude();
    }
    public void setLicenseKey(String license){
        startUpConfig.setLicenseKey( license );
        createWikitude();
    }
    public void captureScreen(Boolean mode){
        int insideMode;
        if(mode){
            insideMode = ArchitectView.CaptureScreenCallback.CAPTURE_MODE_CAM_AND_WEBVIEW;
        }else{
            insideMode = ArchitectView.CaptureScreenCallback.CAPTURE_MODE_CAM;
        }
        Log.d(TAG,"CaptureScreen called, MODE: "+ String.valueOf(insideMode));
        this.captureScreen(insideMode,ctxManager);
    }
    public void loadWorld(){
        Log.d(TAG,this.url);
        try{
            Log.d(TAG,this.url);
            this.load(this.url);
        }catch(IOException e){
            Log.e(TAG,e.getMessage());
        }
        
    }
    public void setLat(Double lat){
        this.lat = lat;
    }
    public void setLng(Double lng){
        this.lng = lng;
    }
    public void updateLocation(){
        this.setLocation(this.lat,this.lng,100f);
    }
    public void setJS(String s){
        this.javascript = s;
    }
    public void callJS(){
        this.callJavascript(this.javascript);
    }
}

