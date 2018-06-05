//
//  LoginFacebookViewController.swift
//  FoodOrder
//
//  Created by Vu Ngoc Cong on 5/14/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginFacebookViewController: UIViewController {

    
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
        fbLogin()
    }
    
    func fbLogin() {
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) {
            (result, err) in
            if (err == nil) {
                print("Loginn Successfully !")
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    DataServices.shared.getDataLogin()
                }
            }else{
                print("Login Failed")
            }
        }
    } 

}
