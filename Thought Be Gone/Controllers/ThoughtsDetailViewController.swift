//
//  ThoughtsDetailViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/30/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class ThoughtsDetailViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK:- Properties
    var thought: DataSnapshot?
    var currentUserUID: String?
    var imageName = ""
    
    //NOTE: In current app incarnation, when the user hits the nav bar back button, the thought is deleted.
    //TODO: Make time sensitive thoughts, ala Snapchat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //grab the info from the dictionary
        retrieveThoughtsForCurrentUser()

        // Do any additional setup after loading the view.
    }
    
    private func retrieveThoughtsForCurrentUser() {
        if let thoughtsDictionary = thought?.value as? NSDictionary {
            if let description = thoughtsDictionary["description"] as? String {
                if let imageURL = thoughtsDictionary["imageURL"] as? String {
                    //if we're here, we hae the imageURL and the description
                    messageLabel.text = description
                    //Shoutout to SDWebImage squad
                    guard let url = URL(string: imageURL) else { return }
                    guard let imageName = thoughtsDictionary["imageName"] as? String else { return }
                    self.imageName = imageName
                    imageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
    
    //MARK:- Self-destructing thoughts
    override func viewWillDisappear(_ animated: Bool) {
        //1. Delete thought from list of snaps
        deleteThoughtFromDatabase()
        
        //2. Destroy the corresponding images from the service storage
        deletePictureMessageFromDatabase()
    }
    
    func deleteThoughtFromDatabase() {
        guard let uid = currentUserUID else { return }
        Database.database().reference().child("users").child(uid).child("snaps").child(thought!.key).removeValue()
    }
    
    func deletePictureMessageFromDatabase() {
        Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
    }

}
