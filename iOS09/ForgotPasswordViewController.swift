//
//  ForgotPasswordViewController.swift
//  iOS09
//
//  Created by admin on 12.11.17.
//  Copyright © 2017 admin. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
    }
    
    
    // Reset Password Action
    @IBAction func submitAction(_ sender: Any) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return(true)
    }
    
}

