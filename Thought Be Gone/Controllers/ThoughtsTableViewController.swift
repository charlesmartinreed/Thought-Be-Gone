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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //what messages are available? Check the database
        checkForNewThoughts()
    }
    
    private func checkForNewThoughts() {
        //get the current user's info
        if let currentUseruUID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(currentUseruUID).child("snaps").observe(.childAdded) { (snapshot) in
                //we want to grab the number of snapshots and add them to an array
                self.thoughts.append(snapshot)
                self.tableView.reloadData()
            }
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
        return thoughts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let thought = thoughts[indexPath.row]
        
        //list who the thought is sent from
        if let thoughtsDictionary = thought.value as? NSDictionary {
            if let fromEmail = thoughtsDictionary["from"] as? String {
                cell.textLabel?.text = fromEmail
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
                }
            }
        }
    }
   

}
