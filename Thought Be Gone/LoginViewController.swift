//
//  LoginViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/28/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    //MARK:- Properties
    var handle: AuthStateDidChangeListenerHandle?
    var signupMode = false
    
    //MARK:- Auth listener for handling user state changes
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            //do stuff
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:- IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton){
        if emailTextField.text != "" && passwordTextField.text != "" {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            loginExistingUser(email: email, password: password)
        } else {
            presentAlert(alert: "Accounts require both a username and a password")
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton){
        if emailTextField.text != "" && passwordTextField.text != "" {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            createNewUser(email: email, password: password)
        } else {
            presentAlert(alert: "Accounts require both a username and a password")
        }

    }
    
    //MARK:- Auth methods
    private func createNewUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                print("Unable to sign up", err.localizedDescription)
                self.presentAlert(alert: err.localizedDescription)
            } else {
                if let user = authResult?.user {
                    //add a user to the database with the user's email
                    Database.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                    self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                }
            }
        }
    }
    
    
    private func loginExistingUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                print("Unable to log in", err.localizedDescription)
                self.presentAlert(alert: err.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)

            }
        }
    }
    
    //MARK:- Database schema methods
    
    
    private func presentAlert(alert: String) {
        let ac = UIAlertController(title: "Oh no!", message: alert, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Alright", style: .cancel, handler: { (_) in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
}

