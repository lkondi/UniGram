//
//  RequestViewController.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 12.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        print(FriendSystem.system.requestList)
        
        FriendSystem.system.addRequestObserver {
            print(FriendSystem.system.requestList)
            self.tableView.reloadData()
        }
    }
    
}

extension RequestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Accept", for: UIControlState())
        cell!.emailLabel.text = FriendSystem.system.requestList[indexPath.row].userName
        
        cell!.setFunction {
            let uid = FriendSystem.system.requestList[indexPath.row].uid
            FriendSystem.system.acceptFriendRequest(uid)
        }
        
        // Return cell
        return cell!
    }
    
}
