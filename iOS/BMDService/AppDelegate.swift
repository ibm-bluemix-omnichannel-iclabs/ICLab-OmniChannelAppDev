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

     let appIdTenantId = "APPID tenantId"
     let appRegion = "Services region"
     let pushAPPGUID = "Push Service APPGUID"
     let pushClientSecret = "Push Service ClientSecret"
     let ananlyticsAppName = "Ananlytics service name"
     let ananlyticsApiKey = "Ananlytics service API Key"
     var userID = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
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
        
        BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: self.userID) { (response, status, error) in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(status)")
                self.showAlert(title: "Success!!!", message: "Response during device registration : \(response)" )
                
                let logger = Logger.logger(name: "My Logger")
                
                logger.debug(message: "Successfully registered for push")
                logger.info(message: "Successfully registered for push")
                
                Analytics.log(metadata: ["event": "Successfully registered for push"])

                
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
                
                
            }else{
                print( "Error during device registration \(error) ")
                self.showAlert(title: "Error!!!", message: "Error during device registration \(error)" )
                
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
        

        // show the alert
    }

}

