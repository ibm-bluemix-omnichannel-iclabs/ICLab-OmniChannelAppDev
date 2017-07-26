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

class LoginViewController: UIViewController, UITextFieldDelegate {

     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var containerView: UIView!
    @IBOutlet var activityController: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityController.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
        
        self.userNameText.delegate = self
        self.passwordText.delegate = self
        
        let border = CALayer()
        border.frame = CGRect(x: 6, y: self.userNameText.frame.size.height - 2, width: self.userNameText.frame.size.width - 12, height: 0.2)
        border.borderColor = UIColor.black.cgColor
        border.borderWidth = 0.2
        self.userNameText.layer.addSublayer(border)
        
        
        
        let border1 = CALayer()
        border1.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: 0.2)
        border1.borderColor = UIColor.black.cgColor
        border1.borderWidth = 0.2
        self.containerView.layer.addSublayer(border1)
        
        
        let border2 = CALayer()
        border2.frame = CGRect(x: 0, y: self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: 0.2)
        border2.borderColor = UIColor.black.cgColor
        border2.borderWidth = 0.2
        self.containerView.layer.addSublayer(border2)
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func NeedToImplement(_ sender: Any) {
        print("Have to Implement")
    }
    
    @IBAction func log_inAppID(_ sender: AnyObject) {
                
        activityController.isHidden = false;
      
        //Invoking AppID login
        
        class delegate : AuthorizationDelegate {
            var view:UIViewController
            
            init(view:UIViewController) {
                self.view = view
            }
            public func onAuthorizationSuccess(accessToken: AccessToken, identityToken: IdentityToken, response:Response?) {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.userID = identityToken.name ?? (identityToken.email?.components(separatedBy: "@"))?[0] ?? "Guest"
                
                
                let mainView  = UIApplication.shared.keyWindow?.rootViewController
                let afterLoginView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
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

