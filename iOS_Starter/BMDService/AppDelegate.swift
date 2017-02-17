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

    let appIdTenantId = "ClientId of your APPID Service"
    let appRegion = "your service region"
    let pushAPPGUID = "App Guid of your Push Notification Service"
    let pushClientSecret = "Client Secretof your Push Notification Service"
    let ananlyticsAppName = "BMDService"
    let ananlyticsApiKey = "API Key of your Mobile Ananlytics Service Service"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        return true
    }
    
    func registerForPush() {
        
       
        
    }
    func unRegisterForPush() {
        
    }
    
    func application(_ application: UIApplication, open url: URL, options :[UIApplicationOpenURLOptionsKey : Any]) -> Bool {
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

