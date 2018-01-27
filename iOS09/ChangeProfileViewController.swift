//
//  ChangeProfileViewController.swift
//  iOS09
//
//  Created by admin on 12.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class ChangeProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let database = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    let fileManager = FileManager.default
    let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
    
    //Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    func appearance() {
        
        let uid = Auth.auth().currentUser?.uid
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get Username
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.profileNameTextField.text = username
            
            //Get Subject
            let subject = value?["subject"] as? String ?? ""
            self.subjectNameTextField.text = subject
            
            //Get Subject
            let phone = value?["phone"] as? String ?? ""
            self.phoneNumberTextField.text = phone
        })
        
        //Get picture
        do {
            let files = try self.fileManager.contentsOfDirectory(atPath: "\(imagePath)")
            
            for file in files {
                if "\(imagePath)/\(file)" == self.imageURL.appendingPathComponent("\(uid!).png").path {
                    self.photoImageView.image = UIImage(contentsOfFile: self.imageURL.appendingPathComponent("\(uid!).png").path)
                }
            }
        } catch {
            print("unable to add image from document directory")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        photoImageView.clipsToBounds = true

        profileNameTextField.delegate = self
        subjectNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        appearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //TextFields Actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        self.photoImageView.image = selectedImage
        photoImageView.image = selectedImage
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(imagePath)")
            
            for file in files {
                if "\(imagePath)/\(file)" == imageURL.appendingPathComponent("\(uid!).png").path {
                    try fileManager.removeItem(atPath: imageURL.appendingPathComponent("\(uid!).png").path)
                }
            }
        } catch {
            print("unable to delete image from document directory")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapChangeImage(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Save Profile Picture Change
    
    @IBAction func saveChanges(_ sender: Any) {
        
        if let data = UIImagePNGRepresentation(self.photoImageView.image!) {
            let filename = imageURL.appendingPathComponent("\(uid!).png")
            try? data.write(to: filename)
        }
        
        self.database.child("users").child(uid!).child("username").setValue(self.profileNameTextField.text)
        self.database.child("users").child(uid!).child("subject").setValue(self.subjectNameTextField.text)
        
        self.database.child("users").child(uid!).child("phone").setValue(self.phoneNumberTextField.text)
        
        if self.passwordTextField.text != "" && self.passwordTextField.text == self.confirmPasswordTextField.text {
            Auth.auth().currentUser?.updatePassword(to: self.passwordTextField.text!) { (error) in
                
                if error == nil {
                    
                    print("You have successfully changed your password!")
                    let uid = Auth.auth().currentUser?.uid
                    self.database.child("users").child(uid!).child("password").setValue(self.passwordTextField.text)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        
       self.navigationController?.popViewController(animated: true)
        
    }
}

