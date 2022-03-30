# React Native Wikitude Bridge

# Introduction 
This is a React Native bridge module for [Wikitude](https://www.wikitude.com/) which provides a simple integration to the Wikitude AR SDK. 

## How to install

First install the module via npm and link it up:

```bash
npm install joaquinlom/react-native-wikitude-sdk

react-native link react-native-wikitude-sdk
```
After that completes, you will need to do additional steps for each platform you are supporting:

#### Android

1. Wikitude since 8.9 can be added via Maven, so in order to include it into your proyect you need to  add the maven repository in your android/build.gradle
	```
		repositories{
			 maven {
                url 'https://cdn.wikitude.com/sdk/maven'
            }
		}

		allprojects{
			 maven {
                url 'https://cdn.wikitude.com/sdk/maven'
            }
		}
	```
2. This Library uses Wikitude Version 9.6, but if you need to modify the Version, go to the node_modules/react-native-wikitude-sdk/android/build.gradle
	```
	dependencies{
		implementation 'com.wikitude:js:9.6.0'
	}
	```
3. In your `android/app/src/main/AndroidManifest.xml` file, If you have it, remove the `android:allowBackup="false"` attribute from the `application` node. If you want to set allowBackup, follow the method [here](https://github.com/OfficeDev/msa-auth-for-android/issues/21).

4. If you are upgrading from the last version, you will need to remove the preivious setup.
	- remove the reference to wikitudesdk in the settings.gradle
	- and remove the lib reference from android/app/build.gradle	

### iOS
after install the package, you need to run 'pod install' inside ios folder

```bash
cd ios
pod install
```

make sure that the WikitudeSDK is inside node_modules/react-native-wikitude-sdk/ios

https://stackoverflow.com/questions/24993752/os-x-framework-library-not-loaded-image-not-found

## Usage
You can only have one feature enable, the default is all.
To change the feature you will need to destroy and recreate the component.

if you have a memory leak or a crash because you switch screens, you need to tell Wikitude to 
Stop rendering , to do this you will need to ref the component and call 

```javascript
wikitudeRef.current.stopRendering() and wikitudeRef.current.resumeRendering()
```

## Offline Experiences
You can run wikitude with local experiences, in order to do this, you will need to handle different betweens platforms

### Android
Go to you main project android folder /android/app/src/main ; Create a new folder called assets, inside here you will put your folder with your experiences.
and to use it, just put the ```typescript url property ``` to your index file (Without the extension). 
Example:
	url: 'ARchitectExamples/07_3dModels_4_SnapToScreen/index'

### IOS
Open your xworkspace file , and link a file inside the main folder.(You can drag & drop the file into xcode) 
You need to check that the assets are in the Build phase - Copy Bundle resources. 
Example:
	url: 'assets/ARchitectExamples/07_3dModels_4_SnapToScreen/index'
	P.D- this is also whitout the extension.

### Considerations
On Android, the assets folder naming is no neccessary but it does on IOS, you can do a conditional to set the url


## Online
Just put the url in the property, it's need to be  a public URL.

## Render

```ecmascript 6
<WikitudeView
        ref="wikitudeView"
        style={{ flex: 1 }}
        url={arCloud}
        licenseKey={licenseKey}
        feature={WikitudeView.Geo}
        onJsonReceived={this.onJsonReceived}
        onFinishLoading={this.onFinishLoading}
		onScreenCaptured={this.onScreenCaptured}
      />
```
# Permissions
Wikitude needs the camera for display AR.

## Android
 will ask for permission using the PermissionsAndroid module from React Native. if no permissions was granted, it will render a button to ask again.

## IOS
Please verify the info.plist for the camera permission text, the module only check the camera permission. 
Note- If the users grant permission but goes to the settings and change the permission, it wont ask again for the permission, you need to link the user to the settings page or display a message.



# Methods

- setWorldUrl(url)
	Set the URL to load into the Wikitude View

- callJavascript(str)
	Send a String as a JS, to inject into the ARView and call it.
	
- injectLocation(lat,ln)
	Send location into the view to inject the location of the device, TODO

- stopRendering
	Stops all rendering of the Wikitude View, this will stops the camera also

- resumeRendering
	Resume the current experience, you need to stop first in order to resume.

- captureScreen
	Will take a screenshot and the onScreenCapture will fired with a Base64 image inside the image property (event.image)

# Events
- onJsonReceived(event)
	handles the JSON received event from the Experience

- onFinishLoading(event)
	on Android it might call twice when is a online experience. handles the event when the Experience is finish loading

- onFailLoading(event)
	handles the event when the experinces has an error loading

- onScreeCaptured(event)
	handles when the images is taken, will have a Image property that is a Base64 String.

# How to use the module

You can check this example app [Github](https://github.com/joaquinlom/react-native-wikitude-sdk-example).

## Things to considerate:
- Rigth now, it only had Camera permission, if you need something else you will need to do it mannually
- This is work in progress, it's not ready for production, use it as you own risk.

## ChangeLog
- 1.0.1
	Test the Module agains Wikitude 9.5, improve rendering on IOS and fix an issue when changing architect url
- 1.0.0
	First Commit
