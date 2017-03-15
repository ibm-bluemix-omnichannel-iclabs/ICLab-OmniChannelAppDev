//
//  AppDelegate.swift
//  BMDService
//
//  Created by Anantha Krishnan K G on 16/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import BMSCore
import BluemixAppID
import BMSAnalytics
import BMSPush
import NotificationCenter
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

     let appIdTenantId = "ebf3db78-3cde-44b4-ba92-2a421cf9518c"
     let appRegion = ".stage1.ng.bluemix.net"
     let pushAPPGUID = "cd9f3c08-dad6-482f-a95d-13e35db541fe"
     let pushClientSecret = "de6961a0-bcde-4bbc-aca4-0f81b0419666"
     let ananlyticsAppName = "BMDService"
     let ananlyticsApiKey = "5585daec-30ec-46bc-a31e-af990d404282"
    
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
        
        logger.debug(message: "Fine level information, typically for debugging purposes.")
        logger.info(message: "Some useful information regarding the application's state.")
        logger.warn(message: "Something may have gone wrong.")
        logger.error(message: "Something has definitely gone wrong!")
        logger.fatal(message: "CATASTROPHE!")
        
        // The metadata can be any JSON object
        Analytics.log(metadata: ["event": "something significant that occurred"])

        return true
    }
    
    func registerForPush() {
        
        BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID: pushAPPGUID, clientSecret:pushClientSecret)
        
    }
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
    
    func application(_ application: UIApplication, open url: URL, options :[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return AppID.sharedInstance.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken) { (response, status, error) in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(status)")
                self.showAlert(title: "Success!!!", message: "Response during device registration : \(response)" )
            }else{
                print( "Error during device registration \(error) ")
                self.showAlert(title: "Error!!!", message: "Error during device registration \(error)" )
                
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let message:NSString = "Error registering for push notifications: \(error.localizedDescription)" as NSString
        
        print("Registering for notifications : \(message)")
        self.showAlert(title: "Error!!!", message: "Registering for notifications : \(message)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
    }
    
    func showAlert (title:String , message:String){
        
        // create the alert
        let alert = UIAlertController.init(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil, userInfo: ["title":title,"message":message])

        // show the alert
    }

}

