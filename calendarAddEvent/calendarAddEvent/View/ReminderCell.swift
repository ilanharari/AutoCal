//
//  ReminderCell.swift
//  calendarAddEvent
//
//  Created by Ilan Harari on 4/22/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    
    @IBOutlet weak var reminderCheck: UIImageView!
    
    @IBOutlet weak var reminderNameLbl: UILabel!
    
    @IBOutlet weak var reminderTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
