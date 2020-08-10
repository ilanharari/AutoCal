//
//  ExpensePickerView.swift
//  AutoCal
//
//  Created by Ilan Harari on 5/5/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit

class ExpensePickerView: UIView {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.isOpaque = false
    }
}
