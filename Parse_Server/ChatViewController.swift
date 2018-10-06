//
//  ChatViewController.swift
//  Parse_Server
//
//  Created by Joseph Andy Feidje on 10/4/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import UIKit
import Parse
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var userName = ""
    var generalError = ""
    var messagesArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        onTimer()
        // Do any additional setup after loading the view.
        self.refreshData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messagesArray[indexPath.row]["text"] as? String
        cell.TextLabel.text = message
        
        if let user = messagesArray[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }

//        cell.usernameLabel.text = user
        return cell
    }
    
    
    @objc func onTimer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        let chatMessage = PFObject(className: "Message")
        // Set the Text key to the text of the chatMessageField
        chatMessage["text"] = textMessage.text ?? ""
        chatMessage["user"] = PFUser.current()
        // Save the PFObject
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.textMessage.text = ""
                self.refreshData() // after the message is sent, refresh the data
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func refreshData() {
        // Retrieve the latest messages and reload the table
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.limit = 15
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                print("objects found",objects?.count ?? 0)
                
                if let objects = objects {
                    self.messagesArray = objects
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func generalAlert(){
        let alertController = UIAlertController(title: "Error", message: self.generalError , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in self.onTimer()}))
        self.present(alertController, animated: true)
    }
    
}


