//
//  ViewController.swift
//  AutoCal
//
//  Created by Ilan Harari on 4/6/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remindersArray.count //count = 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduledTable.dequeueReusableCell(withIdentifier: "reminderCell")!
        cell.textLabel?.text = remindersArray[indexPath.item].title
        return cell
    }
    
    @IBOutlet weak var scheduledTable: UITableView!
    @IBOutlet weak var remindersLoading: UIActivityIndicatorView!
    
    var remindersArray: [EKReminder] = []
    let remindersStore = EKEventStore()
    
    override func viewDidLoad() {
        //MARK: View Constructor
        super.viewDidLoad()
        self.remindersLoading.isHidden = false
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .notDetermined:
            self.remindersStore.requestAccess(to: .reminder, completion: {(granted: Bool, error: Error?) -> Void in
                if granted {
                print("Access granted")
                }
                else {
                    print("Access denied")
                }
            })
        case .restricted:
            print("Access restricted")
        case .denied:
            print("Access denied")
        case .authorized:
            print("Access to reminders is authorized")
            remindersStore.fetchReminders(matching: remindersStore.predicateForReminders(in: nil),  completion: { (reminders: [EKReminder]?) -> Void in
                   self.remindersArray = reminders!//FIXME
                print(self.remindersArray)
            })
        @unknown default:
        print("Default")
        } //end switch
        self.scheduledTable.dataSource = self
        self.scheduledTable.delegate = self
        } //end viewDidLoad()
}//end class
