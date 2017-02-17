ICLab-OmniChannelAppDev - An Omni-Channel App with Mobile Capabilities on IBM Bluemix
===================================================

Businesses today invest in multiple with Mobile Capabilities on channels to engage their users. They IBM Bluemix have mobile apps, websites and presence on social media like Facebook, Twitter, etc. They need a seamless, consistent experience across each of these channels in order to drive better engagement and convert leads. Attend this lab to start building such an omni-channel experience today with a set of mobile offerings available on IBM Bluemix. It starts with quickly building the client side of the application using one of the available code starter templates, then propagating the authentication information across channels, and engaging with users across channels and social media, all using services in IBM Bluemix.

##Contents

There are one mobile and one web apps available here. Both sections have starter app and one finished app.

##Requirements

###iOS App

* iOS 10
* Xcode 8.1
* Swift 3.1
* Cocoapods
* Valid signing certificate and Push certificates.

###Web App

* Latest Chrome - 56 (Mac)
* Latest Firefox -51 (Mac)

#SetUp & Run

Before starting the iOS app building open bluemix and do the following,

1. Create a [Bluemix Push service](https://console.stage1.ng.bluemix.net/docs/services/mobilepush/index.html) and configure the service
2. Create a [Bluemix  AppId service](https://console.stage1.ng.bluemix.net/docs/services/appid/index.html#gettingstarted) and enable FaceBook and Google Login
3. Create a [Bluemix Mobile Analytics Service](https://console.stage1.ng.bluemix.net/docs/services/mobileanalytics/index.html#getting-started-with-mobile-analytics)


##iOS - App with AppID, Mobile Analytics and Push Service

1. Go to the `iOS_Starter` app and open the pod file, add the following dependencies there,

```
    target 'BMDService' do
      use_frameworks!
	  pod 'BluemixAppID', :git => 'https://github.com/ibm-bluemix-mobile-services/appid-clientsdk-swift.git', :branch => ‘development’
	  pod 'BMSPush'
	  pod 'BMSAnalytics'
	end
```
2. Do the `pod install`.

3. Open the `BMDService.xcworkspace` app in Xcode

4. Add your `Bundle identifier` and configure for push service.

5. Enable `Push Notificaion` , `Backgrounnd mode -> Remote notifications` and `Keychain Sharing`

6. Go to the `Targets -> Info` and add `URL Types`. Set values for both `Identifier` and `URL Schemes` as `$(PRODUCT_BUNDLE_IDENTIFIER)`

7. Open `AppDelegate.swift` file and add values for the following,

```
     let appIdTenantId = "ClientId of your APPID Service"
     let appRegion = "your service region"
     let pushAPPGUID = "App Guid of your Push Notification Service"
     let pushClientSecret = "Client Secretof your Push Notification Service"
     let ananlyticsAppName = "BMDService"
     let ananlyticsApiKey = "API Key of your Mobile Ananlytics Service Service

```

8. Initialize the `BMSCore`, `APPID` and  `Analytics` SDKs inside `didFinishLaunchingWithOptions` method

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Initialize core
        let bmsclient = BMSClient.sharedInstance
        bmsclient.initialize(bluemixRegion: appRegion)
        
        //Initialize APPID
        let appid = AppID.sharedInstance
        appid.initialize(tenantId: appIdTenantId, bluemixRegion: appRegion)
        let appIdAuthorizationManager = AppIDAuthorizationManager(appid:appid)
        bmsclient.authorizationManager = appIdAuthorizationManager
        
        //Initialize Analytics
        
        Analytics.initialize(appName: ananlyticsAppName, apiKey: ananlyticsApiKey, hasUserContext: true, collectLocation: true, deviceEvents: .lifecycle, .network)
        
        Analytics.isEnabled = true
        Logger.isLogStorageEnabled = true
        Logger.isInternalDebugLoggingEnabled = true
        Logger.logLevelFilter = LogLevel.debug
        
        let logger = Logger.logger(name: "My Logger")
        
        //Example Analytics log messages
        logger.debug(message: "Fine level information, typically for debugging purposes.")
        logger.info(message: "Some useful information regarding the application's state.")
        logger.warn(message: "Something may have gone wrong.")
        logger.error(message: "Something has definitely gone wrong!")
        logger.fatal(message: "CATASTROPHE!")
        
        // The metadata can be any JSON object
        Analytics.log(metadata: ["event": "something significant that occurred"])

        return true
    }
```

9. Add the code to handle `APPID` call back ,

```
 func application(_ application: UIApplication, open url: URL, options :[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return AppID.sharedInstance.application(application, open: url, options: options)
    }
```
10. Create a method named `registerForPush` and initialize `BMSPush`

```
func registerForPush() {
        
        BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID: pushAPPGUID, clientSecret:pushClientSecret)
        
 }

```

11. Create another method `unRegisterForPush` and the following code,

```
func unRegisterForPush() {
        
         BMSPushClient.sharedInstance.unregisterDevice { (response, status, error) in
            
            if error.isEmpty {
                print( "Response during unregistering device : \(response)")
                print( "status code during unregistering device : \(status)")
                UIApplication.shared.unregisterForRemoteNotifications()
            }
            else{
                print( "Error during unregistering device \(error) ")
                
            }
        }
    }
```

12. Add code to register to Push notification Service inside `didRegisterForRemoteNotificationsWithDeviceToken` method

```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken) { (response, status, error) in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(status)")
            }else{
                print( "Error during device registration \(error) ")
                
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message:NSString = "Error registering for push notifications: \(error.localizedDescription)" as NSString
        
        print("Registering for notifications : \(message)")
        
    }
```

13. Add code to handle the `Push Notification`,

```
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
 }
    
func showAlert (title:NSString , message:NSString){
    
    // create the alert
    let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
    
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    // Broadcast the alert
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil, userInfo: ["title":title,"message":message])
}

```

14. Go to `LoginViewController.swift`, and add code to send the `Logger` and `Analytics` data to `Mobile Ananlytics service` . Provide the following code snippet inside `viewDidLoad` method

```
let logger = Logger.logger(name: "My Logger")

        Logger.send(completionHandler: { (response: Response?, error: Error?) in
            if let response = response {
                print("Status code: \(response.statusCode)")
                print("Response: \(response.responseText)")
            }
            if let error = error {
                logger.error(message: "Failed to send logs. Error: \(error)")
            }
        })
        
        Analytics.send(completionHandler: { (response: Response?, error: Error?) in
            if let response = response {
                print("Status code: \(response.statusCode)")
                print("Response: \(response.responseText)")
            }
            if let error = error {
                logger.error(message: "Failed to send analytics. Error: \(error)")
            }
        })
```

15. Inside `LoginViewController.swift` , add code for using `APPID Service` login. Add the code inside ` log_in` method.

```
@IBAction func log_in(_ sender: AnyObject) {
                
        loaderActivity.isHidden = false;
        //Invoking AppID login
        class delegate : AuthorizationDelegate {
            var view:UIViewController
            
            init(view:UIViewController) {
                self.view = view
            }
            public func onAuthorizationSuccess(accessToken: AccessToken, identityToken: IdentityToken, response:Response?) {
              
                let mainView  = UIApplication.shared.keyWindow?.rootViewController
                let afterLoginView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                afterLoginView?.accessToken = accessToken
                afterLoginView?.idToken = identityToken
                DispatchQueue.main.async {
                    mainView?.present(afterLoginView!, animated: true, completion: nil)
                }
            }
            public func onAuthorizationCanceled() {
                print("cancel")
            }
            
            public func onAuthorizationFailure(error: AuthorizationError) {
                print(error)
            }
        }

        AppID.sharedInstance.loginWidget?.launch(delegate: delegate(view: self))
    }

```

16. Go to the `ProfileViewController.swift` and add code for `registering push notification` and `Crashing` app for `Analytics Service`.

   ```
   // Code for crashing the app
   @IBAction func crashApp(_ sender: Any) {
        NSException(name: NSExceptionName(rawValue: "CrashAppButton"), reason: "Crash button was clicked", userInfo: nil).raise()
    }
    
    // Code to register for Push
    @IBAction func registerPush(_ sender: UISwitch) {
        
        if sender.isOn{
            
            appDelegate.registerForPush()
            
        }else{
            
            appDelegate.unRegisterForPush()
        }
    }
   ```

##iOS - Build and Run the app

![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Mobile_LoginPage.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Mobile_APPIDScreen.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Mobile_AddEmail.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Mobile_AddPassword.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Mobile_Profile.png)


##Web App - App with AppID and Push Service

1. Go to the `Web_Starter` app and `manifest.yml` file. Change the `host` and `name` to your website name.

2. Open `config.js` file and add values for following,

```
  authorizationEndpoint: 'Get it from your APPID Service ',
  tokenEndpoint: 'Get it from your APPID Service ',
  clientId: 'Get it from your APPID Service ',
  secret: 'Get it from your APPID Service ',
  redirectURL: 'https://yourwebsiteName.stage1.mybluemix.net/oauth-callback',
  appRegion: "Service region - like .stage1.ng.bluemix.net",
  pushAPPGUID: "Push service App Guid",
  pushClientSecret: "Push service Client Secret"
```

3. Download `Push Service webiste SDKs (BMSPushSDK.js, BMSPushServiceWorker.js)` and `manifest` file from [here](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-javascript-webpush) and keep them inside `public` folder,

4. Go to [Firebase](https://console.firebase.google.com/) and create an app and get `Legacy Server key` and `Sender ID` from `CLOUD MESSAGING` section.

5. Open the `public/manifest.json` file and add values for `name` and `gcm_sender_id`.

6. Open the `prptected.html` file and [Intialize](https://console.stage1.ng.bluemix.net/docs/services/mobilepush/c_chrome_firefox_enable.html) the `BMSPush`. Add the following code in `prptected.html` ,

```
<script src="BMSPushSDK.js"></script>
  <script>
  function registerPush(){

    var bmsPush = new BMSPush()
    function callback(response) {
      alert(response.response)
    }
    var initParams = {
      "appGUID":JSON.parse(window.sessionStorage.getItem('appId')),
      "appRegion":JSON.parse(window.sessionStorage.getItem('appRegion')),
      "clientSecret":JSON.parse(window.sessionStorage.getItem('clientSecret'))
    }

    var userId = JSON.parse(window.sessionStorage.getItem('userId'));
    bmsPush.initialize(initParams, callback)
    bmsPush.registerWithUserId(userId,function(response) {
      alert(response.response)
    })

  }
  </script>>
```

7. Add the `registerPush()` action to `Enable Push` button. - Line number 17,

```
  <button class="button" onclick="registerPush();">Enable Push</button>

```  


##Web App - Push to bluemix and open the website.

1. Go tho the root folder `Web_starter` in your terminal.
2. Run the `CLI` command - `cf api api.stage1.ng.bluemix.net` ,
3. Login to bluemix from CLI using `cf login`. Select your `Organization` and `Space`.
4. Do the `cf push`. This will host your app in Bluemix. 
5. After App is started open - `https://yourwebsitename.stage1.mybluemix.net`. 

>Note : Load your website with <bold>HTTPS</bold>.


![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Web_LoginPage.png)

<!-- ![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Web_APPIDScreen.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Web_AddEmail.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Web_AddPassword.png)
![](https://github.ibm.com/agirijak/BMDService/tree/development/images/Web_Profile.png) -->


