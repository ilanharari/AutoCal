//
//  SchedulerViewController.swift
//  AutoCal
//
//  Created by Ilan Harari on 4/22/20.
//  Copyright © 2020 Ilan Harari. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
class SchedulerVC: UIViewController {
    var eventStore = EKEventStore()
    var reminder: EKReminder!
    
    @IBOutlet weak var expensePicker: UIDatePicker!
    @IBOutlet weak var PlannerView: UILabel!
    
    
    //MARK: ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        PlannerView.text = reminder.title
        
        switch EKEventStore .authorizationStatus(for: .event) {
               
           case .notDetermined:
               print("access to event store undetermined. Trying again now...")
               eventStore.requestAccess(to: .event, completion: {(granted: Bool, error: Error?) -> Void in
                   if granted {
                      print("access granted")
                    //call scheduleEvent()
                   } else {
                       self.accessAlert()
                   }})
           case .restricted:
               print("Access restricted.")
           case .denied:
               self.accessAlert()
           case .authorized:
               print("access authorized")
            //call scheduleEvent()
               
           @unknown default:
               print("@unknown default")
           }
        
    } //end viewDidLoad()
   
    public func accessAlert() -> Void {
        let alert = UIAlertController(title: "Access Denied", message: "Oops! It seems we've lost access to your Calendars. You can change this in Settings -> Privacy -> Calendars -> AutoCal", preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                          NSLog("The \"OK\" alert occured.")
                          }))
                          alert.addAction(UIAlertAction(title: NSLocalizedString("not OK", comment: "Default action"), style: .default, handler: { _ in
                          NSLog("The \"OK\" alert occured.")
                          }))
                          alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "settings segue"), style: .default, handler: { _ in
                           NSLog("The \"OK\" alert occured.")
                          }))
                           
                       }

   //MARK: event scheduler function
    func scheduleEvent(eventDuration: TimeInterval, userCalendar: EKEventStore) {
        //this function finds the FIRST possible window for a task with the given timeInterval can fit.
   
        //First, pull all events for the next 7 days.
    
        
        // Get the appropriate calendar.
//        var calendar = Calendar.current
//
//        // Create the start date components
//        var currentDayComponents = DateComponents()
//        currentDayComponents.day = 0
//        var currentDay = calendar.date(byAdding: currentDayComponents, to: Date(), options: [])
//
//        // Create the end date components.
//        var oneWeekFromNowComponents = DateComponents()
//        oneWeekFromNowComponents.weekday = 7
//        var oneWeekFromNow = calendar.date(byAdding: oneWeekFromNowComponents, to: Date(), options: [])
//
//        // Create the predicate from the event store's instance method.
//        var predicate: NSPredicate? = nil
//        if let anAgo = currentDay, let aNow = oneWeekFromNow {
//            predicate = store.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
//        }
//
//        // Fetch all events that match the predicate.
//        var events: [EKEvent]? = nil
//        if let aPredicate = predicate {
//            events = store.events(matching: aPredicate)
//
//
        
       
        
        //third: starting with the first event that has a start date greater than the current time, compare each event's end date with the next event's start date. If two events start at the same time, use the longer one. Store the interval between these two times.
        
        //fourth: Compare the stored interval with the one in the DatePicker. Determine whether the stored
        //one from the search is greater than or equal to the one in the DatePicker.
            
            
        //Fifth: create an event starting five minutes after the first event has ended and for the duration specified by the DatePicker.
        
        //Note: The user should have a setting in the app to control the "break time" they have between events
        
    
        
    }
    

}
