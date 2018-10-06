//
//  SignUpViewController.swift
//  Parse_Server
//
//  Created by Joseph Andy Feidje on 10/4/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passWordLabel: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var generalError = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = userNameLabel.text
        newUser.email = emailLabel.text
        newUser.password = passWordLabel.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.generalError = error.localizedDescription
                self.generalAlert()
            } else {
                let sms = "User Registered successfully Go back to the Login Page to log in";
                print(sms)
                self.generalError = sms
                // manually segue to logged in view
                self.generalAlert()
                self.clearField()
            }
        }
    }
    
    
    func clearField(){
        userNameLabel.text = ""
        emailLabel.text = ""
        passWordLabel.text = ""
    }
    
    
    @IBAction func Signup(_ sender: UIButton) {
        if EmptyFieldAlert() != true {
            registerUser()
        }
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func EmptyFieldAlert() -> Bool {
        var isFieldEmpty = false
        if userNameLabel.text?.isEmpty == true || passWordLabel.text?.isEmpty == true{
            isFieldEmpty = true
            let alertController = UIAlertController(title: "TextField Empty", message: "This Field can't be Empty.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default
                , handler: { (action) in self.registerUser()}))
            self.present(alertController, animated: true)
            
        }
        return isFieldEmpty;
    }
    
    func generalAlert(){
        let alertController = UIAlertController(title: "Alert", message: self.generalError , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in self.signupButton.isTouchInside}))
        self.present(alertController, animated: true)
    }
    
}
