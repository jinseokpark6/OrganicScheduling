//
//  VRScheduleModel.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/4/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public class VRScheduleModel: NSObject {
    
    public var time: NSDate
    public var day: NSDate
    public var userIndexes: [Int]
    
    public var dayFormatter = NSDateFormatter()
    public var timeFormatter = NSDateFormatter()
    
    override init() {
        self.time = NSDate()
        self.day = NSDate()
        self.userIndexes = [Int]()
        
        super.init()
        
        commonInit()
    }
    
}

extension VRScheduleModel {
    
    func commonInit() {
        dayFormatter.dateFormat = "EE"
        timeFormatter.dateFormat = "ha"
        
        
    }
    
}

extension VRScheduleModel {

    func fetchDay(date: NSDate) -> String {
        return dayFormatter.stringFromDate(date)
    }
    func fetchTime(date: NSDate) -> String {
        return timeFormatter.stringFromDate(date)
    }
    func fetchColor(totalUserCount: Int) -> UIColor {
        let perc = CGFloat(self.userIndexes.count) / CGFloat(totalUserCount)
//        return UIColor(hue: perc, saturation: 0.3, brightness: 0.3, alpha: 1.0)
        return UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: perc)
    }
}
