//
//  ThoughtsDetailViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/30/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThoughtsDetailViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK:- Properties
    var snap: DataSnapshot?
    
    //NOTE: In current app incarnation, when the user hits the nav bar back button, the thought is deleted.
    //TODO: Make time sensitive thoughts, ala Snapchat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
