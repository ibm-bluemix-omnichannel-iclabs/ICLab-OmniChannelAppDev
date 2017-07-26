//
//  AppDelegate.swift
//  BMDService
//
//  Created by Anantha Krishnan K G on 16/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    // Service details
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        //Initialize core
       
        
        //Initialize APPID
        
        
        
        //Initialize Analytics
        
       

        return true
    }
    
    func registerForPush() {
        
        // Initialize Push
        
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, options :[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return AppID.sharedInstance.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Add Push register Call and send Analytics
        
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

