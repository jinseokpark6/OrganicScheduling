//
//  VRUserDetailView.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/4/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public class VRUserDetailView: UIView {

    public var viewOrigin: CGPoint
    public var viewSize: CGSize
    
    override init(frame: CGRect) {
        
        self.viewOrigin = CGPoint()
        self.viewSize = CGSize()
        
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func commonInit() {
        self.backgroundColor = UIColor.blackColor()
    }
    
    public override func reloadInputViews() {
        
        self.frame = CGRect(origin: self.viewOrigin, size: self.viewSize)

        super.reloadInputViews()
        
        
    }
}
