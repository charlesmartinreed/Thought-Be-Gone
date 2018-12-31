//
//  ThoughtsTableViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ThoughtsTableViewController: UITableViewController {
    
    //MARK:- Properties
    var thoughts = [DataSnapshot]()
    var userID: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //what messages are available? Check the database
        checkForNewThoughts()
    }
    
    private func checkForNewThoughts() {
        //get the current user's info
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            Database.database().reference().child("users").child(currentUser.uid).child("snaps").observe(.childAdded) { (snapshot) in
                //we want to grab the number of snapshots and add them to an array
                self.thoughts.append(snapshot)
                self.tableView.reloadData()
            }
            
            //remove deleted snaps from view
            removeDeletedSnapsFromView(userID: userID!)
        }
        
    }
    
    private func removeDeletedSnapsFromView(userID: String) {
        Database.database().reference().child("users").child(userID).child("snaps").observe(.childRemoved) { (snapshot) in
            //we want to loop through each obj inside thoughts array for one that matches the one that was removed
            for thought in self.thoughts {
                //find the correct snap
                var index = 0
                if snapshot.key == thought.key {
                    self.thoughts.remove(at: index)
                }
                    index += 1
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK:- IBActions
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            print("signed out successfully")
            dismiss(animated: true, completion: nil)
        } catch {
            print("unable to sign out")
        }
    }
    
    //MARK:- Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //if there are no new snaps, we'll return a single cell that we'll customize in cellForRowAt
        if thoughts.isEmpty {
            return 1
        } else {
            return thoughts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if thoughts.isEmpty {
            //above, we only return 1 cell in this case
            cell.textLabel?.text = "No new snaps! 🤨"
        } else {
            let thought = thoughts[indexPath.row]
            
            //list who the thought is sent from
            if let thoughtsDictionary = thought.value as? NSDictionary {
                if let fromEmail = thoughtsDictionary["from"] as? String {
                    cell.textLabel?.text = fromEmail
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thought = thoughts[indexPath.row]
        //move to the new view controller
        performSegue(withIdentifier: "viewThoughtsSegue", sender: thought)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //occurs when the user chooses a particular cell
        if segue.identifier == "viewThoughtsSegue" {
            if let destinationVC = segue.destination as? ThoughtsDetailViewController {
                if let thought = sender as? DataSnapshot {
                    destinationVC.thought = thought
                    destinationVC.currentUserUID = userID
                }
            }
        }
    }
   

}
