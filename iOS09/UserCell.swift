//
//  UserCell.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 12.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonFunc: (() -> (Void))!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }
    
}

