//
//  ViewController.swift
//  Parse_Server
//
//  Created by Joseph Andy Feidje on 10/3/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var passWordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var generalError = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        if EmptyFieldAlert() != true {
            loginUser()
        }
    }
    
    func loginUser() {
        let username = userNameLabel.text ?? ""
        let password = passWordLabel.text ?? ""
        print("username --->> ",username," password --------->> ",password)
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.generalError = error.localizedDescription
                self.generalAlert()
            } else {
                print("User logged in successfully",username)
                self.performSegue(withIdentifier: "loginSegue", sender: username)
                // display view controller that needs to shown after successful login
            }
        }
    }
    
    func EmptyFieldAlert() -> Bool {
        var isFieldEmpty = false
        if userNameLabel.text?.isEmpty == true || passWordLabel.text?.isEmpty == true{
            isFieldEmpty = true
        let alertController = UIAlertController(title: "TextField Empty", message: "This Field can't be Empty.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default
            , handler: { (action) in self.loginUser()}))
        self.present(alertController, animated: true)
            
    }
        return isFieldEmpty;
    }
    
    func networkErrorAlert(){
        let alertController = UIAlertController(title: "Network Error", message: "It's Seems there is a network error. Please try again later.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.loginUser()}))
        self.present(alertController, animated: true)
    }
    
    func generalAlert(){
        let alertController = UIAlertController(title: "Error", message: self.generalError , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.loginButton.isTouchInside}))
        self.present(alertController, animated: true)
    }

}

