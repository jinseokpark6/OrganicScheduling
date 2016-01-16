//
//  DetailViewCell.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/27/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

@IBDesignable
public class DetailViewCell: UICollectionViewCell {
    static let cellKindIdentifier = "DetailViewCell"
    static let cellReuseIdentifier = "DetailViewCell"
    
    public var nameLabel: UILabel?
    public var dateLabel: UILabel?
    public var time: NSDate
    public var day: NSDate
    
    public var timeFormatter = NSDateFormatter()
    public var dayFormatter = NSDateFormatter()
    public var birthDateFormatter = NSDateFormatter()
    
    override init(frame: CGRect) {
        self.nameLabel = UILabel(frame: CGRectZero)
        self.dateLabel = UILabel(frame: CGRectZero)
        self.time = NSDate()
        self.day = NSDate()
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.nameLabel = UILabel(frame: CGRectZero)
        self.dateLabel = UILabel(frame: CGRectZero)
        self.time = NSDate()
        self.day = NSDate()
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.nameLabel!.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.nameLabel!.textAlignment = .Left
        self.nameLabel!.font = nameLabel!.font.fontWithSize(10)
        self.contentView.addSubview(self.nameLabel!)
        
        self.dateLabel!.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.dateLabel!.textAlignment = .Right
        self.dateLabel!.font = dateLabel!.font.fontWithSize(7)
        self.contentView.addSubview(self.dateLabel!)

        
        self.timeFormatter.dateFormat = "h:mma"
        self.dayFormatter.dateFormat = "EE"
        self.birthDateFormatter.dateFormat = "MMM d, y"
        
    }
    
    public override func reloadInputViews() {
        super.reloadInputViews()
        
        let timeLabel = self.timeFormatter.stringFromDate(self.time)
        let dayLabel = self.dayFormatter.stringFromDate(self.day)
        self.nameLabel!.text = "\(dayLabel), \(timeLabel)"

    }
    
    // Prevents cells from using other cells' attributes
    public override func prepareForReuse() {
        super.prepareForReuse()
        

        if self.nameLabel != nil {
            self.nameLabel!.removeFromSuperview()
            self.nameLabel = nil
        }
        if self.dateLabel != nil {
            self.dateLabel!.removeFromSuperview()
            self.dateLabel = nil
        }

    }
}

extension DetailViewCell {
    
    func fetchBirthDayStringFromBirthDate(date: NSDate) -> String {
        return self.birthDateFormatter.stringFromDate(date)
    }
    func fetchTimeStringFromDate(day: NSDate, time: NSDate) -> String {
        let newTime = NSCalendar.currentCalendar().dateByAddingUnit(
            .Minute,
            value: 30,
            toDate: time,
            options: NSCalendarOptions(rawValue: 0))

        return "\(self.dayFormatter.stringFromDate(day)), \(self.timeFormatter.stringFromDate(time)) - \(self.timeFormatter.stringFromDate(newTime!))"
    }
}
