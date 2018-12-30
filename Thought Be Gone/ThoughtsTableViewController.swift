//
//  ThoughtsTableViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import FirebaseAuth

class ThoughtsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

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
    
//    @IBAction func handleAddThoughtButtonTapped() {
//        //needs:
//        //1. what picture to send
//        //2. what message to send with it
//        //3. who to send message to
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   

}
