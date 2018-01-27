//
//  ProfileViewController.swift
//  iOS09
//
//  Created by admin on 29.11.17.
//  Copyright © 2017 admin. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let storage = Storage.storage().reference()
    let database = Database.database().reference()
    
    let fileManager = FileManager.default
    let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
    
    //Outlets
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    func appearance() {
        
        let uid = Auth.auth().currentUser?.uid
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get Username
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.profileName.text = username
            
            //Get Email
            let email = value?["email"] as? String ?? ""
            self.emailAddress.text = email
            
            //Get Subject
            let subject = value?["subject"] as? String ?? ""
            self.subjectName.text = subject
            
            //Get Subject
            let phone = value?["phone"] as? String ?? ""
            self.phoneNumber.text = phone
            })
        
        //Get picture
        do {
            let files = try self.fileManager.contentsOfDirectory(atPath: "\(imagePath)")
            
            for file in files {
                if "\(imagePath)/\(file)" == self.imageURL.appendingPathComponent("\(uid!).png").path {
                    self.imageView.image = UIImage(contentsOfFile: self.imageURL.appendingPathComponent("\(uid!).png").path)
                }
            }
        } catch {
            print("unable to add image from document directory")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        appearance()
        
    }
    
    //Delete Action
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

