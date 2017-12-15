//
//  ScheduleTableViewCell.swift
//  
//
//  Created by Lydia Kondylidou on 12.12.17.
//

import Foundation
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

