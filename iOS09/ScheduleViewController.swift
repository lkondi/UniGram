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
    
    var events = [Event]()
    var category: String?
    var name: String = ""
    var image: UIImage?
    var eventIds: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
    loadEvents(){ signedEvents in
            if let savedEvents = signedEvents {
                self.events = savedEvents
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
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        let event = events[indexPath.row]
        
        cell.eventName.text = event.eventName
        cell.eventImage.image = event.eventImage
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
  
    private func loadEvents(completion: @escaping([Event]?) -> Void)  {
        
       /* database.child(uid!).observeSingleEvent ( of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let array = value?["signedUpEvents"] as? NSArray ?? []
            self.eventIds = array
            print(array)
        })*/
        
        //So bekommst du die Info über die Events für die man sich angemeldet hat
        var signedEvents = [Event]()
        //var event = [String]()
        
        database.child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let signedUp = value?["signUpEvents"] as? NSArray ?? []
            self.eventIds = signedUp
        })
        
        database.child("events").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                // Get eventKey
                for i in 0..<self.eventIds.count {
                    print(self.eventIds[i])
                    if self.eventIds[i] as! _OptionalNilComparisonType == child.value {
                        let value = child.value as? NSDictionary
                        let eventName = value?["eventName"] as? String ?? ""
                        self.name = eventName
                        print(eventName)
                        //Get picture
                        //jetzt wird andere Mehode benutzt weil man die Fotos lokal speichert
                        
                        
                        let uff = Event(eventName: self.name, eventImage: self.image, eventKey: child.value as! String)
                        signedEvents.append(uff)
                        completion(signedEvents)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
}
