//
//  RemindersViewController.swift
//  calendarAddEvent
//
//  Created by Ilan Harari on 4/16/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.myReminders.count)
        return self.myReminders.count
                 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//this function provides the prototype
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderNotScheduledCell")!
        cell.textLabel?.text = myReminders[indexPath.item].title
        return cell
                 }
    
    
  var remindersStore = EKEventStore() //instantiating database
  var myReminders: [EKReminder] = []
 
    
    func pullReminders(store: EKEventStore) {
      remindersStore.fetchReminders(matching: remindersStore.predicateForReminders(in: nil),  completion: { (reminders: [EKReminder]?) -> Void in
      //initialize myReminders[] with reminders
        self.myReminders = reminders!
       
                     }//end closure
                 )
        
    } //end func pullReminders()
    @IBOutlet weak var remindersTable: UITableView!
    override func viewDidLoad() {
    super.viewDidLoad()
    self.remindersStore = EKEventStore()
    
        
        switch EKEventStore.authorizationStatus(for: .reminder) {
                case .notDetermined:
                    print("Access to event store not determined")
                    self.remindersStore.requestAccess(to: .reminder, completion:
                {(granted: Bool, error: Error?) -> Void in
                    if granted {
                        print("Access granted")
                    } else {
                        print("Access denied")
                    }
            })
                case .restricted:
                    print("Access restricted")
                case .denied:
                      print("Access denied")
                case .authorized:
                   print("Authorized")
                    pullReminders(store: remindersStore)
                @unknown default:
                 print("Hello")
                } //end switch
    }//end viewDidLoad()
    
      
//      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          //FIXME
//    }
//
//      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         //FIXME
//      }
//

}

