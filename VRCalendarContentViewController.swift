//
//  VRCalendarContentViewController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public class VRCalendarContentViewController: UIView {

    // MARK: - Public Properties
    public let calendarView: VRCalendarView
    public let scrollView: UIScrollView


    // MARK: - Initialization
    
    public init(calendarView: VRCalendarView, frame: CGRect) {
        self.calendarView = calendarView
        scrollView = UIScrollView(frame: frame)
        super.init(frame: CGRectZero)
    }
    
    
    /// IB Initialization
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
