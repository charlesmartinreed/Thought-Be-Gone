//
//  SelectReceipientViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import Firebase

class SelectReceipientViewController: UITableViewController {

    //MARK:- Properties
    var thoughtDescription = ""
    var downloadURL = ""
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the current users
        obtainUsersFromRemoteDatabase()
    }

    private func obtainUsersFromRemoteDatabase() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            //get the user's information - email and UUID
            var user = User()
            
            if let userDictionary = snapshot.value as? NSDictionary {
                if let email = userDictionary["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key //the generated key created as the user is added to the database via autoID
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK:- Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set up the message to be sent
        
        let user = users[indexPath.row]

        //set up a dictionary to represent all the info a thought should have
        if let fromEmail = Auth.auth().currentUser?.email {
            let snap = [
                "from": fromEmail,
                "description": thoughtDescription,
                "imageURL": downloadURL
            ]
            
            //send the snap to the proper user by saving it to the database schema
            Database.database().reference().child("users").child(user.uid!).child("snaps").childByAutoId().setValue(snap)
            
            //once the snap has been successfully sent, pop them back
            navigationController?.popToRootViewController(animated: true)
        }
        
   
        
    }
    

}
