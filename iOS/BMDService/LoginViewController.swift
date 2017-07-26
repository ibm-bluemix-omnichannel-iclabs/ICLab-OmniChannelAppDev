//
//  ViewController.swift
//  BMDService
//
//  Created by Anantha Krishnan K G on 16/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit


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
        
    }

}

