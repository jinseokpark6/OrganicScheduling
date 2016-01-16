//
//  VRScheduleViewDelegate.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/13/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

@objc
public protocol VRScheduleViewDelegate {
    func presentationMode() -> VRScheduleViewPresentationMode

    func shouldShowAllDay() -> Bool

}
