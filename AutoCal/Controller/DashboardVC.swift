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
    var reminderSelected : EKReminder!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remindersArray.count //count = 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduledTable.dequeueReusableCell(withIdentifier: "reminderCell")!
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = remindersArray[indexPath.item].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reminderSelected = remindersArray[indexPath.row]
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
            let alert = UIAlertController(title: "Access Denied", message: "Oops! It seems we've lost access to your Reminders. You can change this in Settings -> Privacy -> Reminders -> AutoCal", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        case .authorized:
            print("Access to reminders is authorized")
            remindersStore.fetchReminders(matching: remindersStore.predicateForReminders(in: nil),  completion: { (reminders: [EKReminder]?) -> Void in
                   self.remindersArray = reminders!//FIXME
               
                DispatchQueue.main.async {
                self.scheduledTable.reloadData()
                    self.remindersLoading.isHidden = true
                }
               
            })
        @unknown default:
        print("Default")
        } //end switch
        self.scheduledTable.dataSource = self
        self.scheduledTable.delegate = self
        } //end viewDidLoad()
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let schedulerVC = segue.destination as? SchedulerVC {
            schedulerVC.reminder = reminderSelected //reminderSelected is nil
        }
    }
    @IBAction func didTapInfo(_ sender: Any) {
        
        reminderSelected = remindersArray[scheduledTable.indexPathForSelectedRow?.row ?? 0]
    }
    
}//end class
