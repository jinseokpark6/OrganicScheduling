//
//  VRCalendarEventController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/7/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import EventKit

class VRCalendarEventController: UIViewController {

    var popOverController: UIPopoverPresentationController
    
    var eventTableView: UITableView
    
    var calendars: [EKCalendar]? = []
    let eventStore = EKEventStore()
    var calendarList: [String]? = []

    
    init() {
        
        self.popOverController = UIPopoverPresentationController(presentedViewController: UIViewController(), presentingViewController: UIViewController())
        self.eventTableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.eventTableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.addSubview(self.eventTableView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonInit() {
        self.popOverController.delegate = self
        
        self.eventTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VRCalendarEventController {
    
    func importEvents() {
        
        self.checkCalAuthStatus()
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
            // keep asking for permission
        }
    }
    
    
    func requestAccessToCal() {
        eventStore.requestAccessToEntityType(EKEntityType.Event) { (accessGranted:Bool, error:NSError?) -> Void in
            
            if accessGranted {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadCal()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in

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
            
            
        }
        
    }

    
}

extension VRCalendarEventController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension VRCalendarEventController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell")! as UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel!.text = "Name"
            } else if indexPath.row == 1 {
                cell.textLabel!.text = "Location"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        else if section == 1 { return 1 }
        else if section == 2 { return 3 }
        else { return 1 }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension VRCalendarEventController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return ""
        }
    }
}
