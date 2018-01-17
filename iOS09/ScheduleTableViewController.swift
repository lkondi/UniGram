//
//  ScheduleViewController.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 09.12.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ScheduleTableViewController: UITableViewController {
        
    //MARK: Properties
    let database = Database.database().reference()
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser?.uid
    
    //Filemanager
    let fileManager = FileManager.default
    let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var events = [Event]()
    var category: String?
    var name: String = ""
    var date: String = ""
    var location: String = ""
    var image: UIImage?
    var eventIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View Did Load - view: \(self.view)")
   
        loadEvents(){ signedEvents in
            if let savedEvents = signedEvents {
                self.events = savedEvents
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("events: \(events.count)")
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        let event = events[indexPath.row]
        
        cell.eventName.text = event.eventName
        cell.eventImage.image = event.eventImage
        cell.eventLocation.text = event.eventLocation
        cell.eventDate.text = event.eventDate
    
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
  
    private func loadEvents(completion: @escaping([Event]?) -> Void)  {

        var signedEvents = [Event]()
        let imagePath = imageURL.path
        
        database.child("users").child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let signedUp = value?["signUpEvents"] as? NSArray ?? []
            self.eventIds = signedUp as! [String]
        })
        
        database.child("events").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                // Get eventKey
                for i in 0..<self.eventIds.count {
                    if self.eventIds[i] == child.key {
                        let value = child.value as? NSDictionary
                        //get name
                        let eventName = value?["eventName"] as? String ?? ""
                        self.name = eventName
                        //get date
                        let eventDate = value?["eventDate"] as? String ?? ""
                        self.date = eventDate
                        //get location
                        let eventLocation = value?["eventLocation"] as? String ?? ""
                        self.location = eventLocation
                        
                      /* let eventImage = value?["image"] as? String ?? ""
                        if (eventImage == "") {
                            self.image = UIImage(named: "LogoFoto")
                        } else {
                            let url = URL(string: eventImage)
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                if error != nil {
                                    print (error!)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.image = UIImage(named: "LogoFoto")
                                }
                            }).resume()}
                        */
                        
                        //Get picture
                        do {
                            let files = try self.fileManager.contentsOfDirectory(atPath: "\(imagePath)")
                            
                            for file in files {
                                let name = child.key
                                if "\(imagePath)/\(file)" == self.imageURL.appendingPathComponent("\(name).png").path {
                                    self.image = UIImage(contentsOfFile: self.imageURL.appendingPathComponent("\(name).png").path)
                                }
                            }
                        } catch {
                            print("unable to add image from document directory")
                        }
                        
                        let param = Event(eventName: self.name, eventImage: self.image, eventKey: child.key, eventDate: self.date, eventLocation: self.location)
                        signedEvents.append(param)
                        completion(signedEvents)
                    }
                }
            }
        })
    }
}
