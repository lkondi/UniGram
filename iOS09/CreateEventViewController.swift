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
    let uid = Auth.auth().currentUser?.uid
    
    let fileManager = FileManager.default
    let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
    
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
    var mainEventTableVC: EventTableViewController?
    var myImage: UIImage?
    
     //Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var numberPeople: UITextField!
    @IBOutlet weak var additionalInfo: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
    
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
                //Get Events Info
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
                
                //Get picture
                let value_picture = value?["image"] as? String ?? ""
                if (value_picture != "") {
                    let url = URL(string: value_picture)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print (error!)
                            return
                        }
                        self.myImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.eventImage.image = self.myImage
                        }
                    }).resume()
                } else {
                    print("error show event image")
                    self.eventImage.image = UIImage(named: "LogoFoto")
                }
            }) { (error) in
                print(error.localizedDescription)
            }

        }
        
        let uid = Auth.auth().currentUser?.uid
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            //Get Events Array
            let value = snapshot.value as? NSDictionary
            let array1 = value?["eventsAdmin"] as? NSArray ?? []
            for i in 0 ..< array1.count {
                let eventAdmin = array1[i] as! String
                self.createdEventsID.append(eventAdmin)
                if (self.eventKey != "") {if (eventAdmin == self.eventKey) {
                    self.isCreator = true
                }
              }
            }
            
            let array2 = value?["signUpEvents"] as? NSArray ?? []
            for i in 0 ..< array2.count {
                let signUpEvent = array2[i] as! String
                self.signUpEventsID.append(signUpEvent)
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
                        if self.exist && !self.isCreator {
                            self.saveButton.setTitle("Sign Up", for: .normal)
                            self.deleteButton.isHidden = true
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
                //Get Events Array
                let value = snapshot.value as? NSDictionary
                let array1 = value?["signedUpUsers"] as? NSArray ?? []
                for i in 0 ..< array1.count {
                    let user = array1[i] as! String
                    self.signedUpUsersID.append(user)
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
        myImage = selectedImage
        eventImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //Choose image for the event
    
    @IBAction func chooseImage(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
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
        if isCreator {
            //Save new image
            if let image = myImage {
                let imageName = NSUUID().uuidString
                let storedImage = self.storage.child("images").child(imageName)
                
                if let uploadData = UIImagePNGRepresentation(image) {
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
                                self.database.child("events").child(self.eventKey).child("image").setValue(urlText)
                            }
                        })
                    })
                }
            }
            
            //Save image locally
            do {
                let files = try fileManager.contentsOfDirectory(atPath: "\(imagePath)")
                
                for file in files {
                    let name = eventKey
                    if "\(imagePath)/\(file)" == imageURL.appendingPathComponent("\(name).png").path {
                        try fileManager.removeItem(atPath: imageURL.appendingPathComponent("\(name).png").path)
                    }
                }
            } catch {
                print("unable to add image from document directory")
            }
            
            if let data = UIImagePNGRepresentation(self.eventImage.image!) {
                let filename = imageURL.appendingPathComponent("\(eventKey).png")
                try? data.write(to: filename)
            }
            
            //Update the database
            self.database.child("events").child(eventKey).updateChildValues(["eventName": self.eventName.text ?? "", "category": category!, "eventDate": self.eventDate.text ?? "", "eventLocation": self.eventLocation.text ?? "", "numberOfPeople": self.numberPeople.text ?? "", "additionalInfo": self.additionalInfo.text ?? ""])
            
            //Show the updated event
            self.event = Event(eventName: self.eventName.text!, eventImage: self.eventImage.image, eventKey: self.eventKey, eventDate: self.eventDate.text, eventLocation: self.eventLocation.text)
            
            if let delegateVC = self.mainEventTableVC {

                delegateVC.getDataFromEventDetail(event: event!)
            }
            self.navigationController?.popViewController(animated: true)
            
            } else if exist && !isCreator {
            for i in 0 ..< signedUpUsersID.count {
                let userCount = signedUpUsersID[i]
                if (uid! == userCount) {
                    self.isSignedUp = true
                }
            }
            
            //Check if you can still sign up for an event
            if signedUp == people! + 1 || isSignedUp {
                saveButton.isEnabled = false
                
                let alertController = UIAlertController(title: "Error!", message: "You cannot sign up for this event!",  preferredStyle: .alert)
            
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
            } else {
                signUpEventsID.append(eventKey)
                signedUpUsersID.append(uid!)
                self.database.child("users").child(uid!).child("signUpEvents").setValue(signUpEventsID)
                self.database.child("events").child(eventKey).child("signedUpUsers").setValue(signedUpUsersID)
                
                self.navigationController?.popViewController(animated: true)
                }
            } else {
            //Check if the fields are empty or not
            if eventName.text! == "" || eventLocation.text! == "" || additionalInfo.text! == "" || numberPeople.text! == "" || eventDate.text == "" || Int(numberPeople.text!) == nil {
                let alertController = UIAlertController(title: "Error", message: "Please fill in the text fields",  preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                //Save the new event
                eventUid = self.database.child("events").childByAutoId()
                eventKey = (eventUid?.key)!
                
                if let image = myImage {
                    let imageName = NSUUID().uuidString
                    let storedImage = self.storage.child("images").child(imageName)
                    
                    if let uploadData = UIImagePNGRepresentation(image) {
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
                }
                
                //Save image locally
                if let data = UIImagePNGRepresentation(self.eventImage.image!) {
                    let filename = imageURL.appendingPathComponent("\(eventKey).png")
                    try? data.write(to: filename)
                }
                
                eventUid?.setValue(["eventName": self.eventName.text, "category": category, "eventDate": self.eventDate.text, "eventLocation": self.eventLocation.text, "numberOfPeople": self.numberPeople.text, "additionalInfo": self.additionalInfo.text, "admin": uid])
        
                //Save created events for the user
                createdEventsID.append(eventKey)
                signedUpUsersID.append(uid!)
                signUpEventsID.append(eventKey)
                self.database.child("users").child(uid!).child("eventsAdmin").setValue(createdEventsID)
                self.database.child("users").child(uid!).child("signUpEvents").setValue(signUpEventsID)
                self.database.child("events").child(eventKey).child("signedUpUsers").setValue(signedUpUsersID)
                
                event = Event(eventName: self.eventName.text!, eventImage: self.eventImage.image, eventKey: self.eventKey, eventDate: self.eventDate.text, eventLocation: self.eventLocation.text)
                
                if let delegateVC = self.mainEventTableVC {
                    delegateVC.getDataFromEventDetail(event: event!)
                }
               
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        var array = [String]()
        
        createdEventsID = createdEventsID.filter {$0 != eventKey}
        signUpEventsID = signUpEventsID.filter {$0 != eventKey}

        for i in 0..<signedUpUsersID.count {
            database.child("users").child(signedUpUsersID[i]).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let arrayEvents = value?["signUpEvents"] as? Array ?? []
                for i in 0 ..< arrayEvents.count {
                    array.append(arrayEvents[i] as! String)
                }
                array = array.filter {$0 != self.eventKey}
                self.database.child("users").child(self.signedUpUsersID[i]).child("signUpEvents").setValue(array)
                array.removeAll()
            })
        }
        
        //Delete pictures saved locally
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(imagePath)")
            
            for file in files {
                let name = eventKey
                if "\(imagePath)/\(file)" == imageURL.appendingPathComponent("\(name).png").path {
                    try fileManager.removeItem(atPath: imageURL.appendingPathComponent("\(name).png").path)
                }
            }
        } catch {
            print("unable to add image from document directory")
        }
    
        self.database.child("users").child(uid!).child("eventsAdmin").setValue(createdEventsID)
        self.database.child("users").child(uid!).child("signUpEvents").setValue(signUpEventsID)
        self.database.child("events").child(eventKey).removeValue()
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
