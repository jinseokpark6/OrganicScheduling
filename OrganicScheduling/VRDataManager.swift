//
//  VRDataManager.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/5/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit


private let YearUnit = NSCalendarUnit.Year
private let MonthUnit = NSCalendarUnit.Month
private let DayUnit = NSCalendarUnit.Day
private let AllUnits = YearUnit.union(MonthUnit).union(DayUnit)
private let calendar = NSCalendar.currentCalendar()
private let currentDate = NSDate()

private let TIME_COUNT = 48
private let DAY_COUNT = 7

public class VRDataManager {
    
//    public var components: NSDateComponents
//    
//    public var calendar: NSCalendar
//    public var date: NSDate
    
    public init() {
//        self.calendar = NSCalendar.currentCalendar()
//        self.date = NSDate()
//        self.components = calendar.components(AllUnits, fromDate: date)
    }
}

extension VRDataManager {
    
    public static func getNSDataFromFile(fileName: String, typeName: String) -> NSData {
        
        if let path = NSBundle.mainBundle().pathForResource("\(fileName)", ofType: "\(typeName)") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                
                return data
                
            } catch let error as NSError {
                fatalError("\(error)")
            }
        } else {
            fatalError("Invalid filename/path!")
        }
        return NSData()
    }
}

extension VRDataManager {
    
    public static func getJSONObjectFromData(data: NSData) -> NSDictionary {
        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
            return jsonObj
            
        } catch let error as NSError {
            fatalError("\(error)")
        }
    }
}

// MARK: - Retrieve Schedule Data

extension VRDataManager {
    
    public static func updateScheduleModelsFromJSONObject(object: NSDictionary, models: [[VRScheduleModel]]) -> [[VRScheduleModel]] {
        
        var tempModels = models
        
        if let times = object["times"] as? [AnyObject] {
            for index in 0..<times.count {
                if let userIndexes = times[index]["users"] as? [Int] {
                    let itemIndex = index / TIME_COUNT
                    let sectionIndex = index % TIME_COUNT

                    tempModels[sectionIndex][itemIndex].userIndexes = userIndexes
                }
            }
        }
        
        return tempModels
    }
}


// MARK: - Retrieve User Data

extension VRDataManager {

    public static func getUserModelsFromJSONObject(object: NSDictionary) -> [VRUserModel] {
        
        var userModels = [VRUserModel]()
        
        if let users = object["directors"] as? [AnyObject] {
            for user in users {
                let userModel = VRUserModel()
                if let name = user["name"] as? String {
                    userModel.userName = name
                }
                if let birthDate = user["birth"] as? [String: Int] {
                    userModel.userBirthDate = self.getDateFromBirthData(birthDate)
                }
                if let id = user["id"] as? Int {
                    userModel.userId = id
                }
                userModels.append(userModel)
            }
        }
        return userModels
    }

    public static func getNameArrayFromJSONObject(object: NSDictionary) -> [String] {
        
        var names = [String]()
        
        if let users = object["directors"] as? [AnyObject] {
            for user in users {
                if let name = user["name"] as? String {
                    names.append(name)
                }
            }
        }
        return names
    }
    
    public static func getBirthDateArrayFromJSONObject(object: NSDictionary) -> [NSDate] {
        
        var dates = [NSDate]()
        
        if let users = object["directors"] as? [AnyObject] {
            for user in users {
                if let birthData = user["birth"] as? [String: Int] {
                    let newDate = self.getDateFromBirthData(birthData)
                    dates.append(newDate)
                }
            }
        }
        return dates
    }
    
    public static func getDateFromBirthData(data: [String: Int]) -> NSDate {
        let components = calendar.components(AllUnits, fromDate: currentDate)
        for (element, number) in data {
            if element == "year" {
                components.year = number
            } else if element == "month" {
                components.month = number
            } else if element == "day" {
                components.day = number
            }
        }
        return calendar.dateFromComponents(components)!
    }
}


extension VRDataManager {
    

}






