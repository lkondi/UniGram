//
//  EventTableViewController.swift
//  iOS09
//
//  Created by admin on 29.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import os.log

class EventTableViewController: UITableViewController {
    
    //MARK: Properties
    let database = Database.database().reference()
    let storage = Storage.storage().reference()
    
    var events = [Event]()
    var arrayIDs = [String]()
    var category: String?
    var name: String = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            navigationItem.title = category
        }
        
        loadEvents(){ arrayEvents in
            if let savedEvents = arrayEvents {
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
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
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
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            guard let eventDetailViewController = segue.destination as? CreateEventViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            eventDetailViewController.category = self.category
            
        case "BackToHomeScreen":
            os_log("Back.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let eventDetailViewController = segue.destination as? CreateEventViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEventCell = sender as? EventTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEvent = events[indexPath.row]
            eventDetailViewController.event = selectedEvent
            eventDetailViewController.category = self.category
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateEventViewController, let event = sourceViewController.event {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing event.
                events[selectedIndexPath.row] = event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else if let sourceViewController = sender.source as? CreateEventViewController, let event = sourceViewController.event {
                // Add a new event.
                let newIndexPath = IndexPath(row: events.count, section: 0)
                
                events.append(event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    private func loadEvents(completion: @escaping([Event]?) -> Void)  {
        var arrayEvents = [Event]()
        
        database.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                //Get Name
                let value = child.value as? NSDictionary
                let cat = value?["category"] as? String ?? ""
                if cat == self.category {
                    let eventName = value?["eventName"] as? String ?? ""
                    self.name = eventName
                    print(eventName)
                    //Get picture
                    let eventImage = value?["image"] as? String ?? ""
                    print(eventImage)
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
                    let event = Event(eventName: self.name, eventImage: self.image, eventKey: child.key)
                    arrayEvents.append(event)
                    completion(arrayEvents)
                    self.tableView.reloadData()
                    
                }
            }
        }) { (error) in
                print(error.localizedDescription)
        }
    }
}

