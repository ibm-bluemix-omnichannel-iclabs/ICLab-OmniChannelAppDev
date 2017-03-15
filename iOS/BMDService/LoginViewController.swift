//
//  ViewController.swift
//  BMDService
//
//  Created by Anantha Krishnan K G on 16/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import BluemixAppID
import BMSCore
import BMSAnalytics


class LoginViewController: UIViewController {

     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var loaderActivity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderActivity.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

}

