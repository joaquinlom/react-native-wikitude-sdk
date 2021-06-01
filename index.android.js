import { NativeModules ,requireNativeComponent ,findNodeHandle,UIManager,PermissionsAndroid,Button, Platform,} from 'react-native';
import React from 'react';
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
            this.setState({hasCameraPermissions: true,isRunning:true})
          } else {
            this.setState({hasCameraPermissions: false})
          }
        } catch (err) {
          console.warn(err);
        }
      }
      console.log("didmount Wikitude SDK index.js");
      this.setState({isRunning: true});
      setTimeout(()=>{
        this.resumeRendering()
      },500);
     ;
    }
    componentWillUnmount(){
      this.setState({isRunning: false});
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
              this.setState({hasCameraPermissions: true,isRunning:true})
            } else {
              this.setState({hasCameraPermissions: false,isRunning:false})
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
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.setUrlMode,
            [newUrl]
          );
        }
        
      
    };
    callJavascript = function(js){
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.callJSMode,
            [js]
          );
        }
    }
    injectLocation = function(lat,lng){
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.injectLocationMode,
            [lat,lng]
          );
        }
    }
    stopRendering = function(){
          if(this.state.hasCameraPermissions){
            UIManager.dispatchViewManagerCommand(
              findNodeHandle(this.refs.wikitudeView),
              UIManager.RNWikitude.Commands.stopARMode,
              []
            );
          }
    }
    resumeRendering = function(){
      console.log('Calling resumeRendering');
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.resumeARMode,
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
            //this.resumeRendering();
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

      if(hasPermission){
          return <WKTView ref={e => this.wikitudeRef = e} 
              isRunning={this.state.isRunning}
              {...this.props}
              onJsonReceived={this.onJsonReceived} 
              onFailLoading={this.onFailLoading}
              onFinishLoading={this.onFinishLoading}
              onScreenCaptured={this.onScreenCaptured}/>;
      }else{
          return <Button title="Request Permission" onPress={this.requestPermission}/>;
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
    isPOI: PropTypes.bool,
    isRunning: PropTypes.bool,  
  };
  
var WKTView = requireNativeComponent('RNWikitude', WikitudeView, {
  nativeOnly: {
    'isRunning': true,
  }
});

module.exports = { 
    WikitudeView
  };