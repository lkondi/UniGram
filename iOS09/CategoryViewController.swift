//
//  CategoryViewController.swift
//  
//
//  Created by Lydia Kondylidou on 14.11.17.
//

import Foundation
import UIKit

class CategoryViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var categoryItems: [CategoryItem] = []
    
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
        
        //display data from MenuItems.plist
        cell.categoryItemNameLabel?.text = item.name
        cell.categoryItemImageView?.image = UIImage(named: item.image)
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier: String
        switch indexPath.row {
        case 0: //For "one"
            segueIdentifier = "sportSegue"
        default: //For "three"
            segueIdentifier = "danceSegue"
        }
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    
}
