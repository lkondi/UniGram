//
//  ScheduleTableViewCell.swift
//  iOS09
//
//  Created by Elena Terzieva on 03.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


