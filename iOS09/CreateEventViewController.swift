//
//  CreateEventViewController.swift
//  iOS09
//
//  Created by admin on 29.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import os.log

class CreateEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let storage = Storage.storage().reference()
    let database = Database.database().reference()
    
    var event: Event?
    var eventKey: String = ""
    var createdEventsID = [String]()
    var signUpEventsID = [String]()
    var signedUpUsersID = [String]()
    var eventUid: DatabaseReference?
    var isCreator = false
    var exist = false
    var isSignedUp = false
    var people: Int?
    var signedUp: Int = 0
    var category: String?
    
    
     //Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var numberPeople: UITextField!
    @IBOutlet weak var additionalInfo: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        eventName.delegate = self
        eventDate.delegate = self
        eventLocation.delegate = self
        numberPeople.delegate = self
        additionalInfo.delegate = self
        
        if let event = event {
            navigationItem.title = event.eventName
            eventName.text = event.eventName
            eventImage.image = event.eventImage
            
            eventKey = event.eventKey
            database.child("events").child(eventKey).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get Events Info
                let value = snapshot.value as? NSDictionary
                let date = value?["eventDate"] as? String ?? ""
                self.eventDate.text = date
                
                let location = value?["eventLocation"] as? String ?? ""
                self.eventLocation.text = location
                
                let people_int = value?["numberOfPeople"] as? String ?? ""
                self.numberPeople.text = people_int
                self.people = Int(self.numberPeople.text!)
                
                let info = value?["additionalInfo"] as? String ?? ""
                self.additionalInfo.text = info
                
                let signedUp = value?["signedUpUsers"] as? NSArray ?? []
                self.signedUp = signedUp.count
            })
        }
        
        let uid = Auth.auth().currentUser?.uid
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            //Get Events Array
            let value = snapshot.value as? NSDictionary
            let array1 = value?["eventsAdmin"] as? NSArray ?? []
            for i in 0 ..< array1.count {
                let uff = array1[i] as! String
                self.createdEventsID.append(uff)
                if (self.eventKey != "") {if (uff == self.eventKey) {
                    self.isCreator = true
                    print("is creator is in load true")
                    print(self.isCreator)
                }
              }
            }
            
            let array2 = value?["signUpEvents"] as? NSArray ?? []
            for i in 0 ..< array2.count {
                let uff = array2[i] as! String
                self.signUpEventsID.append(uff)
                }
            }) { (error) in
            print(error.localizedDescription)
        }
        
        if (eventKey != "") {
            database.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let value = child.key
                    if (value == self.eventKey) {
                        self.exist = true
                        if self.exist && self.isCreator == false {
                            self.saveButton.setTitle("Sign Up", for: .normal)
                            self.eventName.isEnabled = false
                            self.eventDate.isEnabled = false
                            self.eventLocation.isEnabled = false
                            self.numberPeople.isEnabled = false
                            self.additionalInfo.isEnabled = false
                            self.eventImage.isUserInteractionEnabled = false
                        }
                    }
                }
            })
            
            database.child("events").child(eventKey).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get Events Array
                let value = snapshot.value as? NSDictionary
                let array1 = value?["signedUpUsers"] as? NSArray ?? []
                for i in 0 ..< array1.count {
                    let uff = array1[i] as! String
                    self.signedUpUsersID.append(uff)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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
        eventImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "BackToEventList":
                guard let eventDetailViewController = segue.destination as? EventTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                eventDetailViewController.category = self.category
            
            default:
                // Configure the destination view controller only when the save button is pressed.
                guard let button = sender as? UIButton, button == saveButton else {
                    os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                    return
                }
        
                let name = eventName.text ?? ""
                let photo = eventImage.image
                if (eventKey == "") {
                    eventUid = self.database.child("events").childByAutoId()
                    eventKey = (eventUid?.key)!
                }

                event = Event(eventName: name, eventImage: photo, eventKey: eventKey)
            }
        }
    
    //Choose image for the event
    
    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        //imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Cancel Create Event
    @IBAction func cancelCreateEvent(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //Save Event / Edit or Sign up if not Creator
    @IBAction func saveEvent(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        print("is creator is in saveevent :")
        print(isCreator)
        if isCreator == true {
            self.database.child("events").child(eventKey).updateChildValues(["eventName": self.eventName.text ?? "", "category": category!, "eventDate": self.eventDate.text ?? "", "eventLocation": self.eventLocation.text ?? "", "numberOfPeople": self.numberPeople.text ?? "", "additionalInfo": self.additionalInfo.text ?? ""])
            }
        else if exist && !isCreator {
            for i in 0 ..< signedUpUsersID.count {
                let uff = signedUpUsersID[i]
                if (uid! == uff) {
                    self.isSignedUp = true
                    print("he is signed up already")
                    }
            }

            if signedUp == people! + 1 || isSignedUp {
                saveButton.isEnabled = false
                let alertController = UIAlertController(title: "Number of people reached!", message: "No more people can sign up for this event!",  preferredStyle: .alert)
            
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            } else {
                signUpEventsID.append(eventKey)
                signedUpUsersID.append(uid!)
                self.database.child("users").child(uid!).child("signUpEvents").setValue(signUpEventsID)
                self.database.child("events").child(eventKey).child("signedUpUsers").setValue(signedUpUsersID)
                }
            } else {
            let imageName = NSUUID().uuidString
            let storedImage = self.storage.child("categories_images").child(imageName)
        
            if let uploadData = UIImagePNGRepresentation(self.eventImage.image!) {
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
                            self.eventUid?.child("image").setValue(urlText)
                        }
                    })
                })
            }
        
            if eventName.text == "" || eventLocation.text == "" || additionalInfo.text == "" || numberPeople.text == "" || eventDate.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please fill in the text fields",  preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                eventUid?.setValue(["eventName": self.eventName.text, "category": category, "eventDate": self.eventDate.text, "eventLocation": self.eventLocation.text, "numberOfPeople": self.numberPeople.text, "additionalInfo": self.additionalInfo.text, "admin": uid])
        
                //Save created events for the user
                createdEventsID.append(eventKey)
                signedUpUsersID.append(uid!)
                signUpEventsID.append(eventKey)
                self.database.child("users").child(uid!).child("eventsAdmin").setValue(createdEventsID)
                self.database.child("users").child(uid!).child("signUpEvents").setValue(signUpEventsID)
                self.database.child("events").child(eventKey).child("signedUpUsers").setValue(signedUpUsersID)
        
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventScreen")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
