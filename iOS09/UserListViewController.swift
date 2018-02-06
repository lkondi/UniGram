//
//  UserListViewController.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 12.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        FriendSystem.system.getCurrentUser { (user) in
            self.usernameLabel.text = user.userName
        }
        
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
    }
    
}

extension UserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.emailLabel.text = FriendSystem.system.userList[indexPath.row].userName
        
        cell!.setFunction {
            let uid = FriendSystem.system.userList[indexPath.row].uid
            FriendSystem.system.sendRequestToUser(uid)
        }
        
        // Return cell
        return cell!
    }
    
}

