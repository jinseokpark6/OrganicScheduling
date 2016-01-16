//
//  ViewController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/22/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var calendars: [EKCalendar]? = []
    let eventStore = EKEventStore()
    var calendarList: [String]? = []
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var calendarsTableView: UITableView!
    var calendarView = UIView()
    var entireView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        calendarView.alpha = 0
        calendarView.frame = CGRect(x: 0, y: self.view.frame.height/3, width: self.view.frame.width, height: self.view.frame.height/3)
        calendarView.backgroundColor = UIColor.brownColor()
        self.view.addSubview(calendarView)
//        // 1
//        let eventStore = EKEventStore()
//        
//        // 2
//        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event){
//        case .Authorized:
//            insertEvent(eventStore)
//        case .Denied:
//            print("Access Denied")
//        case .NotDetermined:
//            
//            // 3
//            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
//                {[weak self] (granted: Bool, error: NSError?) -> Void in
//                    if granted {
//                        self!.insertEvent(eventStore)
//                    } else {
//                        print("Access denied")
//                    }
//                })
//        default:
//            print("Case Default")
//        }
        
    }

//    func insertEvent(store: EKEventStore) {
//        // 1
//        let calendars = store.calendarsForEntityType(EKEntityType.Event)
//            
//        
//        for calendar in calendars {
//            // 2
//            if calendar.title == "ioscreator" {
//                // 3
//                let startDate = NSDate()
//                // 2 hours
//                let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
//                
//                // 4
//                // Create Event
//                var event = EKEvent(eventStore: store)
//                event.calendar = calendar
//                
//                event.title = "New Meeting"
//                event.startDate = startDate
//                event.endDate = endDate
//                
//                // 5
//                // Save Event in Calendar
//                var error: NSError?
//                let result = store.saveEvent(event, span: EKSpan.ThisEvent, error: &error)
//                
//                if result == false {
//                    if let theError = error {
//                        print("An error occured \(theError)")
//                    }
//                }
//            }
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        checkCalAuthStatus()
    }
    
    func checkCalAuthStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch(status) {
        case EKAuthorizationStatus.NotDetermined:
            requestAccessToCal()
        case EKAuthorizationStatus.Authorized:
            loadCal()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            needPermissionView.fadeIn(1.0)
        }
    }
    
    
    func requestAccessToCal() {
        eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error:NSError?) -> Void in
            
            if accessGranted {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadCal()
                    self.refreshTableView()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.needPermissionView.fadeIn(1.0)
                })
            }
        }
    }
    
    func loadCal() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)

        for calendar in self.calendars! {
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            let predicate = eventStore.predicateForEventsWithStartDate(oneMonthAgo, endDate: oneMonthAfter, calendars: [calendar])
            let events = eventStore.eventsMatchingPredicate(predicate)
            print("EVENTS: ")
            print(events)
        }
        
        refreshTableView()
    }

    func refreshTableView() {
        calendarsTableView.hidden = false
        calendarsTableView.reloadData()
    }
    
    
    @available(iOS 8.0, *)
    @IBAction func goToSettingsButtonTapped(sender: AnyObject) {
        let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(openSettingsUrl!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.textLabel!.text = calendars![indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        calendarView.fadeIn(0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

