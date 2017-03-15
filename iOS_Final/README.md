BMDService - iOS Final App
===================================================


This is a completed iOS app. 

Before starting the iOS app building open bluemix and do the following,

1. Create a [Bluemix Push service](https://console.stage1.ng.bluemix.net/docs/services/mobilepush/index.html) and configure the service
2. Create a [Bluemix  AppId service](https://console.stage1.ng.bluemix.net/docs/services/appid/index.html#gettingstarted) and enable FaceBook and Google Login
3. Create a [Bluemix Mobile Analytics Service](https://console.stage1.ng.bluemix.net/docs/services/mobileanalytics/index.html#getting-started-with-mobile-analytics)


Please follow the steps to run the app,

1. Do `pod install`
2. open `BMDService.xcworkspace`.
3. Add `Bundle Identifier` and configure the push signing credentials
4. Add the following `capabilities`

   - Push Notifications
   - KeyChain sharing
   - Background Modes - Remote notifications, Background fetch

5. Open the `AppDelegate.swift` and add values for following,

```
     let appIdTenantId = "ClientId of your APPID Service"
     let appRegion = "your service region"
     let pushAPPGUID = "App Guid of your Push Notification Service"
     let pushClientSecret = "Client Secretof your Push Notification Service"
     let ananlyticsAppName = "BMDService"
     let ananlyticsApiKey = "API Key of your Mobile Ananlytics Service Service
```