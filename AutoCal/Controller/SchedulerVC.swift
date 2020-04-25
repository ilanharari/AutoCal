//
//  SchedulerViewController.swift
//  AutoCal
//
//  Created by Ilan Harari on 4/22/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit

class SchedulerVC: UIViewController {

    @IBOutlet weak var lowPriority: PriorityMenuButton!
    
    @IBOutlet weak var mediumPriority: PriorityMenuButton!
    
    @IBOutlet weak var highPriority: PriorityMenuButton!
    
    @IBOutlet weak var priorityMenu: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    } //end viewDidLoad()
    
    /*
   
     
     
     
     
     
     
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
