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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func log_in(_ sender: AnyObject) {
                
        loaderActivity.isHidden = false;
        //Invoking AppID login
    }

}

