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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var userName = ""
    var generalError = ""
    var messagesArray = [PFObject]()
    var refreshControl: UIRefreshControl!
    let imageSize = 100
    let baseURL = "https://api.adorable.io/avatars/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        indicatorSet()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatViewController.didPullTorefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        onTimer()
        // Do any additional setup after loading the view.
        self.refreshData()
    }
    
    @objc func didPullTorefresh(_ refreshControl: UIRefreshControl){
        refreshData()
    }
    
    func indicatorSet(){
        if indicator.isAnimating == true {
            indicator.stopAnimating()
            indicator.isHidden = true
        }
        else{
            indicator.isHidden = true
            indicator.startAnimating()
        }
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
            let identifier = user.username
//            let avatarURL = URL(string: baseURL+"\(imageSize)/\(identifier).png")
//            print("---------------------->>> ",avatarURL!)
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
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
                self.indicator.startAnimating()
                print("objects found",objects?.count ?? 0)
                
                if let objects = objects {
                    self.messagesArray = objects
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func generalAlert(){
        let alertController = UIAlertController(title: "Alert", message: self.generalError , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in self.onTimer()}))
        self.present(alertController, animated: true)
    }
    
}


