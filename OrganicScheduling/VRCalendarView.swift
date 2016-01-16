//
//  VRCalendarView.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public typealias ContentViewController = VRCalendarContentViewController

public class VRCalendarView: UIView {

    public var manager: VRCalendarManager!
    public var appearance: VRCalendarViewAppearance!
    
    // MARK: - Calendar View Delegate
    
    @IBOutlet public weak var calendarDelegate: AnyObject? {
        set {
            if let calendarDelegate = newValue as? VRCalendarViewDelegate {
                delegate = calendarDelegate
            }
        }
        
        get {
            return delegate
        }
    }
    
    public var delegate: VRCalendarViewDelegate? {
        didSet {
            if manager == nil {
                manager = VRCalendarManager(calendarView: self)
            }
            
            if appearance == nil {
                appearance = VRCalendarViewAppearance()
            }
            
//            if touchController == nil {
//                touchController = TouchController(calendarView: self)
//            }
//            
//            if coordinator == nil {
//                coordinator = Coordinator(calendarView: self)
//            }
//            
//            if animator == nil {
//                animator = Animator(calendarView: self)
//            }
//            
//            if calendarMode == nil {
//                loadCalendarMode()
//            }
        }
    }

    // MARK: - Initialization
    
    public init() {
        super.init(frame: CGRectZero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// IB Initialization
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
