//
//  CollectionViewCell.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

@IBDesignable
public class CollectionViewCell: UICollectionViewCell {
    static let cellKindIdentifier = "CollectionViewCell"
    static let cellReuseIdentifier = "CollectionViewCell"

    public var label: UILabel?
    public var day: NSDate
    public var time: NSDate
    public var color: UIColor

    
    override init(frame: CGRect) {
        self.label = UILabel()
        self.day = NSDate()
        self.time = NSDate()
        self.color = UIColor()
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.label = UILabel()
        self.day = NSDate()
        self.time = NSDate()
        self.color = UIColor()
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.label!.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.label!.textAlignment = .Right
        self.label!.font = label!.font.fontWithSize(10)
        self.contentView.addSubview(self.label!)
        

    }
    
    
    // Prevents cells from using other cells' attributes
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.day = NSDate()
        self.time = NSDate()
        if self.label != nil {
            self.label!.removeFromSuperview()
            self.label = nil
        }
    }
}
