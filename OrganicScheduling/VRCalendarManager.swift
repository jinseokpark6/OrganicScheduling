//
//  VRCalendarManager.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

private let YearUnit = NSCalendarUnit.Year
private let MonthUnit = NSCalendarUnit.Month
private let WeekUnit = NSCalendarUnit.WeekOfMonth
private let WeekdayUnit = NSCalendarUnit.Weekday
private let DayUnit = NSCalendarUnit.Day
private let AllUnits = YearUnit.union(MonthUnit).union(WeekUnit).union(WeekdayUnit).union(DayUnit)


public final class VRCalendarManager {

    // MARK: - Private properties
    private var components: NSDateComponents
    private unowned let calendarView: VRCalendarView

    public var calendar: NSCalendar
    
    // MARK: - Public properties
    public var currentDate: NSDate

    
    public init(calendarView: VRCalendarView) {
        self.calendarView = calendarView
        currentDate = NSDate()
        calendar = NSCalendar.currentCalendar()
        components = calendar.components(MonthUnit.union(DayUnit), fromDate: currentDate)
        
    }

    
    
    
}
