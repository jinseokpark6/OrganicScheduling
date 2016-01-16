//
//  VREventModel.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/15/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import EventKit


public class VREventModel {
    
    public var title: String
    
    var calendars: [EKCalendar]? = []
    let eventStore = EKEventStore()
    var calendarList: [String]? = []

    
    init(title: String) {
        self.title = title
    }

    func checkCalAuthStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch(status) {
        case EKAuthorizationStatus.NotDetermined:
            requestAccessToCal()
        case EKAuthorizationStatus.Authorized:
            loadCal()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            break
//            needPermissionView.fadeIn(1.0)
        }
    }
    
    
    func requestAccessToCal() {
        eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error:NSError?) -> Void in
            
            if accessGranted {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadCal()
//                    self.refreshTableView()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.needPermissionView.fadeIn(1.0)
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
        
//        refreshTableView()
    }

}
