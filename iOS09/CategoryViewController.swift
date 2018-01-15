//
//  CategoryViewController.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 22.11.17.
//  Copyright © 2017 Lydia Kondylidou. All rights reserved.
//
import Foundation
import UIKit
import os.log

class CategoryViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var categoryItems: [CategoryItem] = []
    var category: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryItems = CategoryItemsManager.sharedManager.loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell") as! CategoryItemTableViewCell
        let item = categoryItems[indexPath.row]
        
        //display data from CategoryItems.plist
        cell.categoryItemNameLabel?.text = item.name
        cell.categoryItemImageView?.image = UIImage(named: item.image)
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ProfileView":
            os_log("Adding a new event.", log: OSLog.default, type: .debug)
            
        case "ScheduleView":
            os_log("Scheduled events.", log: OSLog.default, type: .debug)
            
        case "EventList":
            
            guard let selectedEventCell = sender as? CategoryItemTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            guard let eventDetailViewController = segue.destination as? EventTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
                
            }
            let selectedEvent = categoryItems[indexPath.row].name
                eventDetailViewController.category = selectedEvent
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

