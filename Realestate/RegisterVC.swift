//
//  RegisterVC.swift
//  Realestate
//
//  Created by nic on 16/4/2019.
//  Copyright © 2019 nic. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    

    
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var requestOutlet: UIButton!
    var phoneNumber: String?
    
    //MARK: Email Registration

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
    
    
    
    
    
    
    
    }
    
    //MARK: IBAction
    
    @IBAction func requestBTN(_ sender: Any) {
        
        if phoneNumberTF.text != ""{
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTF.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil{
                    print("************WWWW::::::: error phone number \(error!.localizedDescription)")
                    return
                }
                
                self.phoneNumber = self.phoneNumberTF.text!
                self.phoneNumberTF.text = ""
                self.phoneNumberTF.placeholder = self.phoneNumber!
                self.phoneNumberTF.isEnabled = false
                self.codeTF.isHidden = false
                self.requestOutlet.setTitle("Register", for: .normal)
                
                UserDefaults.standard.set(verificationID, forKey: kVERIFICATIONCODE)
                UserDefaults.standard.synchronize()
            }
        }
        if codeTF.text != ""{
            FBUser.registerUserWith(phoneNum: phoneNumber!, verificationCode: codeTF.text!) { (error, shouldLogin) in
                if error != nil{
                    print("WWWWW:::::   error \(String(describing: error?.localizedDescription))")
                    return
                }
                if shouldLogin{
                    // goto main view
                    print("goto main view")
                }else{
                    // finish register
                    print("goto registration")
                }
            }
        }
        
    }
    //email register Btn
    @IBAction func registerBTN(_ sender: Any) {
        
        if emailTF.text != "" && nameTF.text != "" && lastNameTF.text != "" && passwordTF.text != "" {
            FBUser.registerUserWith(email: emailTF.text!, password: passwordTF.text!, firstname: nameTF.text!, lastname: lastNameTF.text!) { (error) in
                if error != nil{
                    print("WWWWW::::::: Error registering user with Email: \(String(describing: error?.localizedDescription))" )
                    return
                }
                self.gotoHomeScreen()
            }
        }
    }
    
    
    @IBAction func closedBTN(_ sender: Any) {
        gotoHomeScreen()
    }
    
    // MARK: Helper Function
    
    func gotoHomeScreen(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
        
    }
}
