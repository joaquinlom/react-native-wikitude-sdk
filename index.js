import { NativeModules ,requireNativeComponent ,findNodeHandle,UIManager} from 'react-native';
import React from 'react';
const { WikitudeSdk } = NativeModules;
import PropTypes from 'prop-types';

var wikitudeModule = NativeModules.WikitudeModule;
class WikitudeView extends React.Component {
  
    setWorldUrl = function(newUrl) {
      if (Platform.OS === "android") {
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.refs.wikitudeView),
          UIManager.RNWikitude.Commands.setUrlMode,
          [newUrl]
        );
      } else if (Platform.OS === "ios") {
       return  NativeModules.RNWikitude.setUrl(newUrl,
          findNodeHandle(this.refs.wikitudeView)
        );
      }
      
    };
    callJavascript = function(js){
      if (Platform.OS === "android") {
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.refs.wikitudeView),
          UIManager.RNWikitude.Commands.callJSMode,
          [js]
        );
      } else if (Platform.OS === "ios") {
       return  NativeModules.RNWikitude.callJavascript(js,
          findNodeHandle(this.refs.wikitudeView)
        );
      }
    }
    injectLocation = function(lat,lng){
      if(Platform.OS === "android"){
        UIManager.dispatchViewManagerCommand(
          findNodeHandle(this.refs.wikitudeView),
          UIManager.RNWikitude.Commands.injectLocationMode,
          [lat,lng]
        );
      }else{
        
      }
    }
    stopRendering = function(){
        if(Platform.OS === "android"){
          UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.refs.wikitudeView),
            UIManager.RNWikitude.Commands.stopARMode,
            []
          );
        }
    }
    resumeRendering = function(){
      if(Platform.OS === "android"){
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
      }  
      onFailLoading = (event)=>{
          if(!this.props.onFailLoading){
              return;
          }
          this.props.onFailLoading(event.nativeEvent);
      }
    render() {
      return <WKTView ref="wikitudeView" {...this.props}
      onJsonReceived={this.onJsonReceived} 
      onFailLoading={this.onFailLoading}
      onFinishLoading={this.onFinishLoading}/>;
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
    WikitudeView,
    wikitudeModule
  };
  
  
