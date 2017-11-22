//
//  SignUpViewController.swift
//  iOS09
//
//  Created by admin on 12.11.17.
//  Copyright © 2017 admin. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    //var ref: DatabaseReference!
    let ref = Database.database().reference(fromURL: "https://ios09-2d460.firebaseio.com/")
    
    //Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    //Sign Up Action for email
    
    @IBAction func createAccountAction(_ sender: Any) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        if passwordTextField.text != confirmPassword.text{
            let alertController = UIAlertController(title: "Error", message: "Error! No password match!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    let uid = user?.uid
                    let userReference = self.ref.child("users").child(uid!)
                    let values = ["username": self.userName.text, "email": self.emailTextField.text, "password": self.passwordTextField.text]
                    userReference.updateChildValues(values)
        
                   //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}


