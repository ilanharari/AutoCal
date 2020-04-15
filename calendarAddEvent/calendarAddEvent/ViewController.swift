//
//  ViewController.swift
//  calendarAddEvent
//
//  Created by Ilan Harari on 4/11/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ViewController: UIViewController {
    
    
//    func insertEvent(store: EKEventStore, date: Date, name: String) {
    //
    func insertEvent(store: EKEventStore) {
//        1. The calendars(for:) method returns all calendars that support events. Note: initialize a variable to that method

        let calendars = store.calendars(for: .event) // creates an array of calendars initialized to the calendars on the device. If EKEntityType = .reminder, it will initialize this array to the groups of Reminders on the device.

        
//        2. Check if the previously created calendar "ioscreator" exists
        for calendar in calendars {
            if calendar.title == "Calendar" {
         
//        3. The event has a start date of the current time and end date of 2 hours from the current time

        //                2 hours. NOTE: parameter will need to be duration determined by user
                let endDate = eventDate.date.addingTimeInterval(eventDuration.countDownDuration) //This parameter is SECONDS
            //        4. An event is created with a title of "new meeting"
            let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.startDate = eventDate.date
                event.endDate  = endDate
                event.title = eventName.text
                //        5. The event is saved into the current calendar.
                do {
                    try store.save(event, span: .thisEvent)
                } catch {
                    print("Error saving event in calendar")
                }
            }

        }

    }
    
    @IBOutlet weak var eventDuration: UIDatePicker!
    
    @IBOutlet weak var eventDate: UIDatePicker!
  
    @IBOutlet weak var eventName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        eventDate.datePickerMode = .date
        
    }
    @IBAction func durationChanged(_ sender: Any) {
    }
    
    @IBAction func dateChanged(_ sender: Any) {}
    
    @IBAction func doneClicked(_ sender: Any) {
        //handle the date and name, insert calendar event
        
        //1. create an EKEventStore object
        let eventStore = EKEventStore()
        
        //2. call auth method
        switch EKEventStore.authorizationStatus(for: .event) {
            
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion:
                
                    {[weak self] (granted: Bool, error: Error?) -> Void in
                        if granted {
                            self!.insertEvent(store: eventStore)
                            
                        }
            })
        
            case .restricted:
             print("access denied!")
            case .authorized:
            insertEvent(store: eventStore)
        case .denied:
             print("access denied!")
        @unknown default:
            print("case default")
            } //end switch
        
        
        
        
    }//end doneClicked
}

