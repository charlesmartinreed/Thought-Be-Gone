//
//  SelectPictureViewController.swift
//  Thought Be Gone
//
//  Created by Charles Martin Reed on 12/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:- @IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //MARK:- Properties
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UIImagePickerController allows us to access the stored images on a phone
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
    }
    
    
    @IBAction func selectCameraButtonTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Choose an image", message: "", preferredStyle: .actionSheet)
        
        //Present photo library
        ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            if self.imagePicker != nil {
                self.imagePicker!.sourceType = .photoLibrary
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }))
        
        //Present camera interface
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            if self.imagePicker != nil {
                self.imagePicker!.sourceType = .camera
                self.present(self.imagePicker!, animated: true, completion: nil)
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    //MARK:- Image picker delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //grab the image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        //MARK:- DELETE THIS BEFORE PRODUCTION RELEASE
        messageTextField.text = "test"
        imageAdded = true
        
        //require that there's an image and that thre's a message
        if let message = messageTextField.text {
            if imageAdded && message != ""{
                uploadUserImage(image: imageView.image!)
            } else {
                self.displayAlert(message: "You must provide both an image and a message for your thought.")
            }
        }
    }
    
    fileprivate func uploadUserImage(image: UIImage) {
        //storage folder for Firebase
        let imagesFolder = Storage.storage().reference().child("images")
        
        if let image = imageView.image {
            if let imageData = image.jpegData(compressionQuality: 0.2) {
                //NSUUID = universally unique ID.
                imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil) { (metadata, error) in
                    if let err = error {
                        print("Unable to save image")
                        self.displayAlert(message: err.localizedDescription)
                    } else {
                        //A-OK! Segue to the next view controller
                    }
                }
            }
            
            
        }
        
    }
    
}

//extension SelectPictureViewController: UIImagePickerControllerDelegate {
//}
