//
//  ProfileViewController.swift
//  BMDService
//
//  Created by Anantha Krishnan K G on 16/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import BluemixAppID
import NotificationCenter

class ProfileViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
         appDelegate.registerForPush()

    }
    
    
}
