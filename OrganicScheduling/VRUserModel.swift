//
//  VRUserModel.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/4/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public class VRUserModel {

    public var userName: String
    public var userBirthDate: NSDate
    public var userInfo: String
    
    public var userId: Int
    
    init() {
        self.userName = String()
        self.userBirthDate = NSDate()
        self.userInfo = String()
        
        self.userId = Int()
        
        commonInit()
    }

}

extension VRUserModel {
    
    func commonInit() {
        
        let data = VRDataManager.getNSDataFromFile("Users", typeName: "json")
        let object = VRDataManager.getJSONObjectFromData(data)
        let names = VRDataManager.getNameArrayFromJSONObject(object)
        let dates = VRDataManager.getBirthDateArrayFromJSONObject(object)
        let randomIndex = Int(arc4random_uniform(UInt32(names.count)))

        self.userName = names[randomIndex]
        self.userBirthDate = dates[randomIndex]
        
    }
}