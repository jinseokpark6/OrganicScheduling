//
//  VRScheduleDetailViewController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/27/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public class VRScheduleDetailViewController: UIView {

    private var titleLabel: UILabel
    private var detailLabel: UILabel
    
    public var collectionView: UICollectionView
    public var collectionViewLayout: DetailViewLayout
    public var collectionViewHeader: DetailViewHeader
    public var userDetailView: VRUserDetailView
    public var scheduleModels: [[VRScheduleModel]]
    private let timeCount: Int
    private let dayCount: Int
    
    public var userModels = [VRUserModel]()
    
    public init(timeCount: Int, dayCount: Int) {
        
        self.titleLabel = UILabel()
        self.detailLabel = UILabel()
        self.collectionViewLayout = DetailViewLayout()
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.collectionViewLayout)
        self.collectionViewHeader = DetailViewHeader()
        self.userDetailView = VRUserDetailView()
        
        self.scheduleModels = [[VRScheduleModel]]()
        self.timeCount = timeCount
        self.dayCount = dayCount
        
        super.init(frame: CGRectZero)
        
        commonInit()
    }
    
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VRScheduleDetailViewController {
    
    func commonInit() {

        self.backgroundColor = UIColor.whiteColor()
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.scrollEnabled = true
        self.collectionView.registerClass(DetailViewCell.self, forCellWithReuseIdentifier: DetailViewCell.cellReuseIdentifier)
        self.collectionView.registerClass(DetailViewHeader.self, forSupplementaryViewOfKind: DetailViewHeader.viewKindIdentifier, withReuseIdentifier: DetailViewHeader.viewReuseIdentifier)
        self.collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.collectionView.pagingEnabled = true

        self.addSubview(self.collectionView)
        
        
        
//        playerNames.append("John Mayer")
//        playerNames.append("Vladimir Vlad")
//        playerNames.append("Haru Haru")
//        playerNames.append("Whachicowska Visku")
//        playerNames.append("Whachicowska Visku")
//        playerNames.append("Whachicowska Visku")
//        playerNames.append("Whachicowska Visku")

        self.userDetailView.hidden = true
        self.userDetailView.viewOrigin = self.collectionView.frame.origin
        self.userDetailView.viewSize = self.collectionView.frame.size
        self.userDetailView.reloadInputViews()
        self.addSubview(self.userDetailView)
        
        //
        self.initializeUsers()

    }
}

extension VRScheduleDetailViewController {
    
    //
    func initializeUsers() {
        let data = VRDataManager.getNSDataFromFile("Users", typeName: "json")
        let object = VRDataManager.getJSONObjectFromData(data)
        let updatedUserModels = VRDataManager.getUserModelsFromJSONObject(object)
        self.userModels = updatedUserModels
        
    }
    
    //
    func initializeTimes() {
        let data = VRDataManager.getNSDataFromFile("Schedule", typeName: "json")
        let object = VRDataManager.getJSONObjectFromData(data)
        let updatedScheduleModels = VRDataManager.updateScheduleModelsFromJSONObject(object, models: self.scheduleModels)
        self.scheduleModels = updatedScheduleModels
    }
    
    
}

extension VRScheduleDetailViewController: UICollectionViewDataSource {
    
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DetailViewCell.cellReuseIdentifier, forIndexPath: indexPath) as! DetailViewCell
        
        
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.nameLabel = UILabel()
        cell.nameLabel!.frame = CGRect(x: 5, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
        cell.nameLabel!.textAlignment = .Left
        cell.nameLabel!.font = cell.nameLabel!.font.fontWithSize(10)
        cell.contentView.addSubview(cell.nameLabel!)
        
        cell.dateLabel = UILabel()
        cell.dateLabel!.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width - 5, height: cell.bounds.size.height)
        cell.dateLabel!.textAlignment = .Right
        cell.dateLabel!.font = cell.dateLabel!.font.fontWithSize(7)
        cell.contentView.addSubview(cell.dateLabel!)

        
        let itemIndex = indexPath.item / self.timeCount
        let sectionIndex = indexPath.item % self.timeCount
        let model = self.scheduleModels[sectionIndex][itemIndex]
        
        if indexPath.section == 0 {
            cell.day = model.day
            cell.time = model.time
            
            cell.nameLabel!.text = cell.fetchTimeStringFromDate(cell.day, time: cell.time)
            cell.nameLabel!.textAlignment = .Center
            
            cell.backgroundColor = model.fetchColor(self.userModels.count)
            
        } else {
            
            let userIndexes = model.userIndexes
            
            if indexPath.section - 1 < userIndexes.count {
                let userIndex = self.userModels[userIndexes[indexPath.section - 1]]
                cell.nameLabel!.text = userIndex.userName
                cell.dateLabel!.text = cell.fetchBirthDayStringFromBirthDate(userIndex.userBirthDate)
            }
        }
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.scheduleModels.count - 1) * self.scheduleModels[0].count
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.userModels.count + 1
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.userDetailView.hidden = false
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == DetailViewHeader.viewKindIdentifier {
            return collectionView.dequeueReusableSupplementaryViewOfKind(DetailViewHeader.viewKindIdentifier, withReuseIdentifier: DetailViewHeader.viewReuseIdentifier, forIndexPath: indexPath)
        }
        return UICollectionReusableView()
    }
    
}


extension VRScheduleDetailViewController: UICollectionViewDelegate {
    

}



