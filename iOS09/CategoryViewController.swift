//
//  CategoryViewController.swift
//  iOS09
//
//  Created by admin on 22.11.17.
//  Copyright © 2017 admin. All rights reserved.
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(recognizer:)))
        //tableView?.addGestureRecognizer(tap)
        tap.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView?.indexPathForRow(at: tapLocation) {
                if (self.tableView?.cellForRow(at: tapIndexPath) as? CategoryItemTableViewCell) != nil {
                    //
                    switch tapIndexPath.row {
                    case 4:
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatView")
                        self.present(vc!, animated: true, completion: nil)
                    default: 
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventScreen")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                }
            }
        }
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
            
        case "EventList":
            
            guard let selectedEventCell = sender as? CategoryItemTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            if indexPath.row == 4 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatView")
                self.present(vc!, animated: true, completion: nil)
            } else {
                guard let eventDetailViewController = segue.destination as? EventTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                let selectedEvent = categoryItems[indexPath.row].name
                eventDetailViewController.category = selectedEvent
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

