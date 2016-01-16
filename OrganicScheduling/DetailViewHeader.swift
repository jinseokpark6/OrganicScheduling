//
//  DetailViewHeader.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/27/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public class DetailViewHeader: UICollectionReusableView {
    static let viewKindIdentifier = "DetailViewHeader"
    static let viewReuseIdentifier = "DetailViewHeader"

    public var titleLabel: UILabel
    
    
    public override init(frame: CGRect) {
        titleLabel = UILabel()
        
        super.init(frame: frame)
        
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DetailViewHeader {
    
    func commonInit() {
        titleLabel.backgroundColor = UIColor.whiteColor()
        
        titleLabel.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        titleLabel.text = "CHAR"
        
    }
}

