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

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var successMsg: UILabel!
    
    var accessToken:AccessToken?
    var idToken:IdentityToken?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
       
        super.viewDidLoad()
        

        if let picUrl = idToken?.picture, let url = URL(string: picUrl), let data = try? Data(contentsOf: url) {
            self.profilePic.image = UIImage(data: data)
        }
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2;
        self.profilePic.layer.masksToBounds = true;
        
        if let displayName = idToken?.name {
            self.successMsg.text = "Hi " + displayName + ", Welcome to BMDService 🎉🎊"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.showAlert), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
    }
    
    func showAlert(notification: NSNotification) {
        if let myDict = notification.userInfo as? [String:AnyObject] {
            let alert = UIAlertController.init(title: myDict["title"] as! String? , message: myDict["message"] as! String?, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
    @IBAction func crashApp(_ sender: Any) {
    }
    
    @IBAction func registerPush(_ sender: UISwitch) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
