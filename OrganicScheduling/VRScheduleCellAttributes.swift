//
//  VRScheduleCellAttributes.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/5/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public enum VRScheduleCellAttributes: Int {
    case DateHeight
    case TimeWidth
    case TopBufferHeight
    case BottomBufferHeight
    
    var floatValue: CGFloat {
        switch self {
        case .DateHeight: return 30.0
        case .TimeWidth: return 50.0
        case .TopBufferHeight: return 10.0
        case .BottomBufferHeight: return 10.0
        }
    }
}