import { NativeModules ,requireNativeComponent ,findNodeHandle,UIManager,PermissionsAndroid,Button} from 'react-native';
import React from 'react';
const { WikitudeSdk } = NativeModules;
import PropTypes from 'prop-types';

class WikitudeView extends React.Component {

    constructor(props){
      super(props);

      this.state = {hasCameraPermissions: false};
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
    }
    componentWillUnmount(){
      console.log("Unmounting SDK")
      stopAR();
    }
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
    setWorldUrl = function(newUrl) {
      if (Platform.OS === "android") {
        if(this.state.hasCameraPermissions){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.setUrlMode,
            [newUrl]
          );
        }
        
      } else if (Platform.OS === "ios") {
       return  NativeModules.RNWikitude.setUrl(newUrl,
          findNodeHandle(this.refs.wikitudeView)
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
       return  NativeModules.RNWikitude.callJavascript(js,
          findNodeHandle(this.refs.wikitudeView)
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
        
      }
    }
    stopRendering = function(){
        if(Platform.OS === "android"){
          if(this.state.hasCameraPermissions){
            UIManager.dispatchViewManagerCommand(
              findNodeHandle(this.refs.wikitudeView),
              UIManager.RNWikitude.Commands.stopARMode,
              []
            );
          }
          
        }else{
          return  NativeModules.RNWikitude.stopAR(
            findNodeHandle(this.refs.wikitudeView)
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
        return  NativeModules.RNWikitude.resumeAR(
          findNodeHandle(this.refs.wikitudeView)
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
      }  
      onFailLoading = (event)=>{
          if(!this.props.onFailLoading){
              return;
          }
          this.props.onFailLoading(event.nativeEvent);
      }
    render() {
      const hasPermission = this.state.hasCameraPermissions;

      if(Platform.OS == 'android'){
        if(hasPermission){
          return <WKTView ref="wikitudeView" {...this.props}
              onJsonReceived={this.onJsonReceived} 
              onFailLoading={this.onFailLoading}
              onFinishLoading={this.onFinishLoading}/>;
        }else{
          return <Button title="Request Permission" onPress={this.requestPermission}/>;
        }
      }else{
        return <WKTView ref="wikitudeView" {...this.props}
          onJsonReceived={this.onJsonReceived} 
          onFailLoading={this.onFailLoading}
          onFinishLoading={this.onFinishLoading}/>;
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
  };
  
var WKTView = requireNativeComponent('RNWikitude', WikitudeView);

module.exports = { 
    WikitudeView
  };
  
  
