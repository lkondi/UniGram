//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let storage = Storage.storage().reference()
    let database = Database.database().reference()
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser?.uid
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get Username
            let value_username = snapshot.value as? NSDictionary
            let username = value_username?["username"] as? String ?? ""
            self.profileName.text = username
            
            //Get Email
            let value_email = snapshot.value as? NSDictionary
            let email = value_email?["email"] as? String ?? ""
            self.emailAddress.text = email
            
            //Get Subject
            let value_subject = snapshot.value as? NSDictionary
            let subject = value_subject?["subject"] as? String ?? ""
            self.subjectName.text = subject
            
            //Get Subject
            let value_phone = snapshot.value as? NSDictionary
            let phone = value_phone?["phone"] as? String ?? ""
            self.phoneNumber.text = phone
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameTextField.delegate = self
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        photoImageView.clipsToBounds = true

        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapChangeImage(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        //imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Change Profile Name
    @IBAction func changeProfile(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Change Profile Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            self.profileName.text = text
            
            let uid = Auth.auth().currentUser?.uid
            //self.database.child("users/uid/username").setValue(text)
            self.database.child("users").child(uid!).child("username").setValue(text)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //Change Subject Name
    @IBAction func changeSubject(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Change Subject", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            self.subjectName.text = text
            
            let uid = Auth.auth().currentUser?.uid
            self.database.child("users").child(uid!).child("subject").setValue(text)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Change Phone Number
    @IBAction func changePhone(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Change Phone Number", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            self.phoneNumber.text = text
            
            let uid = Auth.auth().currentUser?.uid
            //self.database.child("users/uid/username").setValue(text)
        self.database.child("users").child(uid!).child("phone").setValue(text)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //Change Password
    @IBAction func changePassword(_ sender: Any) {
        
        let alert = UIAlertController(title: "Change Phone Number", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
        Auth.auth().currentUser?.updatePassword(to: text) { (error) in
            
            if error == nil {
                
                print("You have successfully changed your password!")
                let uid = Auth.auth().currentUser?.uid
                self.database.child("users").child(uid!).child("password").setValue(text)
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
         }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Delete Account Action
    @IBAction func deleteAccountAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete Account", message: "Are you sure?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            var title = ""
            var message = ""
            
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    
                    title = "Error!"
                    message = error.localizedDescription
                    
                } else {
                    
                    title = "Success!"
                    message = "Account has been successfully deleted."
                    
                    let uid = user!.uid
                    self.database.child("users").child(uid).removeValue()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                    
                }
            }
        }
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
     //LogOutFunction
    
    @IBAction func logOutAction(_ sender: Any) {
    
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}

