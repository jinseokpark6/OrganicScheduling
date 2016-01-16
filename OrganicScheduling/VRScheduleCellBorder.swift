//
//  VRScheduleCellBorder.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/13/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public enum VRScheduleCellBorder: Int {
    case Left
    case Right
    case Top
    
    var floatValue: CGFloat {
        switch self {
        case .Left: return 0.5
        case .Right: return 0.5
        case .Top: return 0.2
        }
    }
    
    var colorValue: UIColor {
        switch self {
        case .Left: return UIColor.grayColor()
        case .Right: return UIColor.grayColor()
        case .Top: return UIColor.lightGrayColor()
        }
    }
}