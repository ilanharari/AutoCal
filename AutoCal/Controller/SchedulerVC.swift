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
    var userEvents: [EKEvent] = []
    var busyTime: [DateInterval] = []
    @IBOutlet weak var expensePicker: UIDatePicker!
    @IBOutlet weak var PlannerView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlannerView.text = reminder.title
        switch EKEventStore .authorizationStatus(for: .event) {
        case .notDetermined:
            print("access to event store undetermined. Trying again now...")
            eventStore.requestAccess(to: .event, completion: {(granted: Bool, error: Error?) -> Void in
                if granted {
                    print("access granted")
                    self.userEvents = self.getEvents(eventStore: self.eventStore)
                    
                } else {
                    self.accessAlert()
                }})
        case .restricted:
            print("Access restricted.")
            self.accessAlert()
        case .denied:
            self.accessAlert()
        case .authorized:
            print("access authorized")
            self.userEvents = self.getEvents(eventStore: self.eventStore)
            
        @unknown default:
            print("@unknown default")
        }
        
    } //end viewDidLoad()
    
    @IBAction func schedule(_ sender: Any) {
        if expensePicker.countDownDuration > 0.0 {
            self.busyTime = assignBusyTimes(events: self.getEvents(eventStore: self.eventStore))
            for i in 0...busyTime.count - 2 {
                if busyTime[i].intersects(busyTime[i+1]) {
                    continue
                } else {
                    if let betweenEvents : DateInterval = DateInterval(start: busyTime[i].end, end: busyTime[i+1].start) { //MARK: Question
                        if betweenEvents.duration >= expensePicker.countDownDuration {
                            scheduleEvent(start: betweenEvents.start, eventDuration: expensePicker.countDownDuration, name: reminder.title)
                            break
                        }
                    }
                    
                }
            }
            
        }
    }
    
    
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
    
    func getEvents(eventStore: EKEventStore) -> [EKEvent] { //fetch and sort events
        //Note: Retrieving events from the Calendar database does not necessarily return events in
        //chronological order.To sort an array of EKEvent objects by date, call
        //sortedArrayUsingSelector: on the array, providing the selector
        //for the compareStartDateWithEvent: method.
        guard let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {return []}
        guard let endDate = Calendar.current.date(byAdding: .day, value: 9, to: startDate) else {return []}
        
        var events: [EKEvent] = []
        var predicate: NSPredicate
        predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        //sort events in chronological order
        let  matchingEvents = eventStore.events(matching: predicate).sorted(by: { (e1: EKEvent, e2: EKEvent) -> Bool in
            return e1.compareStartDate(with: e2) == .orderedAscending
            //case: events with the same start date will be ordered by longer event first
            //case: Overlapping events
            //assign e1 a date interval to go
            
        })
        events.append(contentsOf: matchingEvents)
        
        return events
    } //end fetch func
    
    func assignBusyTimes( events: [EKEvent]) -> [DateInterval] {
        
        //Note: The user should have a setting in the app to control the "break time" they have between events
        var busyTime: [DateInterval] = []
        for i in 0...events.count - 1 {
            let eventBlock = DateInterval(start: events[i].startDate, end: events[i].endDate)
            busyTime.append(eventBlock)
        }
        return busyTime
    }
    
    func scheduleEvent(start: Date, eventDuration: TimeInterval, name: String) {
        
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Calendar" {
                let event = EKEvent(eventStore: eventStore)
                event.calendar = calendar
                event.title = reminder.title
                event.startDate = start
                event.endDate = start.addingTimeInterval(eventDuration)
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    print("Error saving event")
                    self.accessAlert()
                }
                
            }
        }
        
        
    }
    
    
    
    
}
