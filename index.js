import { NativeModules ,requireNativeComponent ,findNodeHandle,UIManager,PermissionsAndroid,Button, Platform,} from 'react-native';
import React from 'react';
const { WikitudeSdk } = NativeModules;
import PropTypes from 'prop-types';

class WikitudeView extends React.Component {

    constructor(props){
      super(props);

      this.state = {hasCameraPermissions: false,isRunning:false};
      this.requestPermission = this.requestPermission.bind(this);
    }

    async componentDidMount(){
      if(Platform.OS === 'android'){
        try {
          const granted = await PermissionsAndroid.request(
            PermissionsAndroid.PERMISSIONS.CAMERA,
            {
              title: "Wikitude Needs the Camera",
              message:
                "Wikitude needs the camaera to show cool AR",
              buttonNeutral: "Ask Me Later",
              buttonNegative: "Cancel",
              buttonPositive: "OK"
            }
          );
          if (granted === PermissionsAndroid.RESULTS.GRANTED) {
            this.setState({hasCameraPermissions: true})
          } else {
            this.setState({hasCameraPermissions: false})
          }
        } catch (err) {
          console.warn(err);
        }
      }
<<<<<<< HEAD
      console.log("didmount Wikitude SDK index.js")
      //Sometimes the resume is not calling because the references is wrong
      //this.resumeRendering();
      if(this.props.isPOI && Platform.OS !== 'android'){
        this.resumeRendering();
      }else{
        this.resumeRendering();
      }
    }
    /*
    componentWillMount(){
      console.log("component will mount")
      //this.resumeRendering();
      
    }
    */
    componentWillUnmount(){
      console.log("componentWillUnmount")
      //this.stopRendering();
      if(this.props.isPOI && Platform.OS !== 'android'){
        this.stopRendering();
      }
    }
    componentDidUpdate(){
      console.log("ComponentDidUpdate")
      console.log("Value of URL: ",this.props.url)
      //this.resumeRendering();
    }
    /*
    shouldComponentUpdate(nextProps,nextState){
      
      if(nextProps.url != this.props.url || nextProps.licenseKey != this.props.licenseKey){
        console.log("shouldComponentUpdate: calling resumeRendering")
        //this.resumeRendering();
      }else{
      }
      //return nextProps.url != this.props.url || nextProps.licenseKey != this.props.licenseKey || nextProps.hasCameraPermissions != this.props.hasCameraPermissions ;
    }
    */
    
    
=======
      //console.log("didmount Wikitude SDK index.js")
      //this.resumeRendering();
    }
    componentWillUnmount(){
      console.log("Unmounting SDK index.js")
      this.stopRendering();
    }
    componentDidUpdate(){
      console.log("resume Wikitude SDK index.js")
      //this.resumeRendering();
    }
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
    requestPermission = function(){
      if(Platform.OS === 'android'){
        try {
          PermissionsAndroid.request(
            PermissionsAndroid.PERMISSIONS.CAMERA,
            {
              title: "Wikitude Needs the Camera",
              message:
                "Wikitude needs the camaera to show cool AR",
              buttonNeutral: "Ask Me Later",
              buttonNegative: "Cancel",
              buttonPositive: "OK"
            }
          ).then(granted=>{
            if (granted === PermissionsAndroid.RESULTS.GRANTED) {
              this.setState({hasCameraPermissions: true})
            } else {
              this.setState({hasCameraPermissions: false})
            }
          })
          
        } catch (err) {
          console.warn(err);
        }
      }
    }
    isDeviceSupportingFeature = feature => {
      if(Platform.OS == 'android'){

      }else{
        return  NativeModules.RNWikitude.isDeviceSupportingFeatures(feature,
          findNodeHandle(this.refs.wikitudeView)
        );
      }
    }
    setWorldUrl = function(newUrl) {
      console.log("Set WORLD component")
      //this.stopRendering();
      if (Platform.OS === "android") {
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.setUrlMode,
            [newUrl]
          );
        }
        
      } else if (Platform.OS === "ios") {
       /*return  NativeModules.RNWikitude.setUrl(newUrl,
          findNodeHandle(this.wikitudeRef)
        );*/
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.wikitudeRef),
          UIManager.getViewManagerConfig('RNWikitude').Commands.setUrl,
          [newUrl]
        );
      }
      
    };
    callJavascript = function(js){
      if (Platform.OS === "android") {
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.callJSMode,
            [js]
          );
        }
        
      } else if (Platform.OS === "ios") {
        
       //return  NativeModules.RNWikitude.callJavascript(findNodeHandle(this.wikitudeRef),js);
        
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.wikitudeRef),
          UIManager.getViewManagerConfig('RNWikitude').Commands.callJavascript,
          [js]
        );
      }
    }
    injectLocation = function(lat,lng){
      if(Platform.OS === "android"){
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.injectLocationMode,
            [lat,lng]
          );
        }
      }else{
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.wikitudeRef),
          UIManager.getViewManagerConfig('RNWikitude').Commands.injectLocation,
          [lat,lng]
        );
        /*return  NativeModules.RNWikitude.injectLocation(
          lat,lng,
          findNodeHandle(this)
        );*/
      }
    }
    stopRendering = function(){
        if(Platform.OS === "android"){
          if(this.state.hasCameraPermissions){
            UIManager.dispatchViewManagerCommand(
              findNodeHandle(this),
              UIManager.RNWikitude.Commands.stopARMode,
              []
            );
          }
          
        }else{
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.wikitudeRef),
            UIManager.getViewManagerConfig('RNWikitude').Commands.stopAR,
            []
          );
        }
    }
    resumeRendering = function(){
      if(Platform.OS === "android"){
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.resumeARMode,
            []
          );
        }
      }else{
        
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.wikitudeRef),
          UIManager.getViewManagerConfig('RNWikitude').Commands.resumeAR,
          []
        );
        
      }
    }
    onJsonReceived = (event) => {
        if (!this.props.onJsonReceived) {
          return;
        }
        // process raw event...
        this.props.onJsonReceived(event.nativeEvent);
      }
    onFinishLoading = (event)=> {
          if(!this.props.onFinishLoading){
              return;
          }
          this.props.onFinishLoading(event.nativeEvent);

          if(Platform.OS == 'android'){

          }else{
            this.resumeRendering();
          }
          
      }  
    onFailLoading = (event)=>{
          if(!this.props.onFailLoading){
              return;
          }
          this.props.onFailLoading(event.nativeEvent);
      }
    onScreenCaptured = event =>{
      if(!this.props.onScreenCaptured){
        return;
      }
      this.props.onScreenCaptured(event.nativeEvent);
    }
    captureScreen = (mode) => {
      if (Platform.OS === "android") {
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.captureScreen,
            [mode]
          );
        }
        
      } else if (Platform.OS === "ios") {
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.wikitudeRef),
          UIManager.getViewManagerConfig('RNWikitude').Commands.captureScreen,
          [mode]
        );
        /*return  NativeModules.RNWikitude.captureScreen(mode,
          findNodeHandle(this.refs.wikitudeView)
        );*/
      }
    }
    render() {
      const hasPermission = this.state.hasCameraPermissions;

      if(Platform.OS == 'android'){
        if(hasPermission){
          return <WKTView ref="wikitudeView" {...this.props}
              onJsonReceived={this.onJsonReceived} 
              onFailLoading={this.onFailLoading}
              onFinishLoading={this.onFinishLoading}
              onScreenCaptured={this.onScreenCaptured}/>;
        }else{
          return <Button title="Request Permission" onPress={this.requestPermission}/>;
        }
      }else{
        return <WKTView ref={e => this.wikitudeRef = e} {...this.props}
          onJsonReceived={this.onJsonReceived} 
          onFailLoading={this.onFailLoading}
          onFinishLoading={this.onFinishLoading}
          onScreenCaptured={this.onScreenCaptured}/>;
      }
      
    }
  }
  
  WikitudeView.propTypes = {
    /**
     * A Boolean value that determines whether the user may use pinch
     * gestures to zoom in and out of the map.
     */
    licenseKey: PropTypes.string,
    url: PropTypes.string,
    feature: PropTypes.number,
    onJsonReceived: PropTypes.func,
    onFinishLoading:PropTypes.func,
    onFailLoading:PropTypes.func,
    onScreenCaptured:PropTypes.func,
<<<<<<< HEAD
    isPOI: PropTypes.bool
=======
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
  };
  
var WKTView = requireNativeComponent('RNWikitude', WikitudeView);

module.exports = { 
    WikitudeView
  };
  
  
