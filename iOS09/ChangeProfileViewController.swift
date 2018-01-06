//
//  ChangeProfileViewController.swift
//  iOS09
//
//  Created by admin on 12.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChangeProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let storage = Storage.storage().reference()
    let database = Database.database().reference()
    
    //Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var myImage: UIImage?
    
    
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
            
            //Get picture
            let value_picture = value?["picture"] as? String ?? ""
            if (value_picture != "") {
                let url = URL(string: value_picture)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print (error!)
                        return
                    }
                    self.myImage = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.photoImageView.image = self.myImage
                    }
                }).resume()
            } else {
                print("error change profile")
                self.photoImageView.image = UIImage(named: "Profile")
            }
        }) { (error) in
            print(error.localizedDescription)
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
        myImage = selectedImage
        photoImageView.image = selectedImage
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
        
        let uid = Auth.auth().currentUser?.uid
        
        let imageName = NSUUID().uuidString
        let storedImage = self.storage.child("picture").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(myImage!) {
            storedImage.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: {(url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        self.database.child("users").child(uid!).child("picture").setValue(urlText)
                    }
                })
            })
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
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileScreen")
        present(vc, animated: true, completion: nil)
        
    }
}

