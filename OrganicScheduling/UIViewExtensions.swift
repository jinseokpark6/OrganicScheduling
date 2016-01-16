//
//  UIViewExtensions.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/22/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func fadeIn(animateTime: NSTimeInterval) {
        // Move our fade out code from earlier
        UIView.animateWithDuration(animateTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
            }, completion: nil)
    }
    
    func fadeOut(animateTime: NSTimeInterval) {
        UIView.animateWithDuration(animateTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
}