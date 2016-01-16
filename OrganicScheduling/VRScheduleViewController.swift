//
//  VRScheduleViewController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit



public class VRScheduleViewController: UIViewController {

    var collectionView: UICollectionView
    var collectionViewLayout: VRScheduleViewLayout
    var scheduleModels: [[VRScheduleModel]]
    var scheduleView: UIView
    var scale: CGFloat
    var detailView: VRScheduleDetailViewController
    
    var eventNavigationController: UINavigationController
    var eventView: VRCalendarEventController
    
    var blurEffectView: UIVisualEffectView
    var blurRecognizer: UITapGestureRecognizer
    var pinchRecognizer: UIPinchGestureRecognizer
    var longPressRecognizer: UILongPressGestureRecognizer

    var calendar: NSCalendar
    var dayComponents: NSDateComponents
    var timeComponents: NSDateComponents
    var dayFormatter: NSDateFormatter
    var timeFormatter: NSDateFormatter

    
    public var isLandscape: Bool
    public var isInitialize: Bool

    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height

    
    public let TITLE_CELL = 0
    public let TIME_CELLS = 48
    public let DAY_CELLS = 7
    
    /* Change these values to change the number of cells displayed */
    public let DISPLAY_TIME_CELLS = 24
    public let DISPLAY_DAY_CELLS = 7

    
    public let TIME_ITEM = 1
    public let DAY_ITEM = 1
    
    public let DAY_SECTION = 0
    public let ALL_DAY_SECTION = 1
    public let TOP_BUFFER_SECTION = 2
    
    public let SCHEDULE_VIEW_PADDING = 0.5
    
    public let START_DAY = 0
    public let START_HOUR = 6
    public let START_MIN = 0
    

    public var isCalendar = true
    
    public init(frame: CGRect) {
        

        isLandscape = (UIDevice.currentDevice().orientation.isLandscape.boolValue) ? (true) : (false)
        isInitialize = true
        collectionViewLayout = VRScheduleViewLayout(isLandscape: isLandscape, isInitialize: isInitialize, NUM_TIMES: DISPLAY_TIME_CELLS)
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        scheduleModels = [[VRScheduleModel]]()
        scheduleView = UIView()
        scale = 1.0
        //////////////
        detailView = VRScheduleDetailViewController(timeCount: TIME_CELLS, dayCount: DAY_CELLS)
        //////////////
        eventNavigationController = UINavigationController()
        eventView = VRCalendarEventController()

        
        
        blurEffectView = UIVisualEffectView()
        blurRecognizer = UITapGestureRecognizer()
        pinchRecognizer = UIPinchGestureRecognizer()
        longPressRecognizer = UILongPressGestureRecognizer()
        
        calendar = NSCalendar.currentCalendar()
        timeComponents = NSDateComponents()
        dayComponents = NSDateComponents()
        timeFormatter = NSDateFormatter()
        dayFormatter = NSDateFormatter()
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit() 
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension VRScheduleViewController {
    
    func commonInit() {
        
        //
        let collectionViewHeight = self.view.frame.height - statusBarHeight
        let collectionViewWidth = self.view.frame.width
        
        print("HEIGHT: \(collectionViewHeight)/ WIDTH: \(collectionViewWidth)")


        collectionView.frame.origin = CGPoint(x: 0, y: statusBarHeight)
        collectionView.frame.size.width = (isLandscape) ? collectionViewHeight / 2 : collectionViewWidth
        collectionView.frame.size.height = (isLandscape) ? collectionViewWidth : collectionViewHeight
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollEnabled = true
        
        //
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellReuseIdentifier)
        collectionView.registerClass(VRScheduleViewTopBorder.self, forSupplementaryViewOfKind: VRScheduleViewTopBorder.viewKindIdentifier, withReuseIdentifier: VRScheduleViewTopBorder.viewReuseIdentifier)
        collectionView.registerClass(VRScheduleViewRightBorder.self, forSupplementaryViewOfKind: VRScheduleViewRightBorder.viewKindIdentifier, withReuseIdentifier: VRScheduleViewRightBorder.viewReuseIdentifier)
        collectionView.registerClass(VRScheduleViewLeftBorder.self, forSupplementaryViewOfKind: VRScheduleViewLeftBorder.viewKindIdentifier, withReuseIdentifier: VRScheduleViewLeftBorder.viewReuseIdentifier)

//        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        
        // Decoration Views
        collectionViewLayout.registerClass(VRScheduleViewRightBorder.self, forDecorationViewOfKind: VRScheduleViewRightBorder.viewKindIdentifier)
        
//        collectionViewLayout.TIME_CELLS = self.TIME_CELLS
        
        
        pinchRecognizer.addTarget(self, action: "handlePinch:")
        pinchRecognizer.delegate = self
        pinchRecognizer.cancelsTouchesInView = true
        collectionView.addGestureRecognizer(pinchRecognizer)
        
        longPressRecognizer.addTarget(self, action: "handleLongPress:")
        longPressRecognizer.delegate = self
        longPressRecognizer.cancelsTouchesInView = true
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        // add schedule view to collection view
        scheduleView.backgroundColor = UIColor.yellowColor()
        scheduleView.layer.shadowOffset = CGSizeMake(5, 5)
        scheduleView.layer.shadowRadius = 5
        scheduleView.layer.shadowOpacity = 0.5

        collectionView.addSubview(scheduleView)
        
        // add collection view to entire view
        self.view.addSubview(collectionView)
        
        
        dayComponents.day = START_DAY
        timeComponents.hour = START_HOUR
        timeComponents.minute = START_MIN
        
        timeFormatter.dateFormat = "ha"
        dayFormatter.dateFormat = "EE"
        

        for col in 0...TIME_CELLS {
            
            scheduleModels.append([VRScheduleModel]())
            
            for row in 0..<DAY_CELLS {
                

                let scheduleModel = VRScheduleModel()
                scheduleModel.day = calendar.dateFromComponents(dayComponents)!
                scheduleModel.time = calendar.dateFromComponents(timeComponents)!
                scheduleModels[col].append(scheduleModel)

                dayComponents.day += 1
            }

            dayComponents.day = START_DAY
            timeComponents.minute += 30
        }

        
        // Set the last row of TIME_CELLS equal to the first row (both are 12AM)
        scheduleModels[TIME_CELLS] = scheduleModels[0]
        
        
        self.detailView.scheduleModels = self.scheduleModels
        self.detailView.initializeTimes()
        

        

        
        
        let detailViewBuffer: CGFloat = 15
        
        self.detailView.frame.size = CGSize(width: (self.view.frame.height / 2 - detailViewBuffer * 2), height: self.view.frame.width - statusBarHeight - detailViewBuffer * 2)
        self.detailView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.detailView.alpha = 0
//        self.detailView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.detailView.collectionView.frame.size = CGSize(width: self.detailView.frame.size.width, height: self.detailView.frame.size.height)
        self.detailView.collectionView.reloadData()
        self.view.addSubview(self.detailView)
        
        
        self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        //always fill the view
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.blurEffectView.alpha = 0
        
        
        self.blurRecognizer.addTarget(self, action: "handleBlurTap:")
        self.blurRecognizer.delegate = self
        self.blurEffectView.addGestureRecognizer(self.blurRecognizer)

        self.view.insertSubview(self.blurEffectView, belowSubview: self.detailView)
        
        
        self.eventNavigationController = UINavigationController(rootViewController: self.eventView)
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: "cancelButton")
        self.eventNavigationController.topViewController!.navigationItem.leftBarButtonItem = cancelBtn
        let saveBtn = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "saveButton")
        self.eventNavigationController.topViewController!.navigationItem.rightBarButtonItem = saveBtn

        self.eventView.modalPresentationStyle = UIModalPresentationStyle.Popover
        self.eventView.view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height - statusBarHeight)
        self.eventView.view.frame.origin = CGPoint(x: 0, y: statusBarHeight)
        self.eventView.view.backgroundColor = UIColor.yellowColor()
        self.eventView.title = "New Event"
        
        

    }

    
}

extension VRScheduleViewController: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCell.cellReuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.clearColor().CGColor

        cell.label = UILabel()
        cell.label!.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
        cell.label!.textAlignment = .Right
        cell.label!.font = cell.label!.font.fontWithSize(10)
        cell.contentView.addSubview(cell.label!)
        

        
        if indexPath.item == 0 && indexPath.section == 0 {
            cell.label!.textAlignment = .Center
            cell.label!.text = "WEEKLY"
            
        } else if indexPath.item == 0 {
            if indexPath.section == ALL_DAY_SECTION {
                cell.label!.text = "ALL DAY"
                cell.backgroundColor = UIColor.lightGrayColor()
                
            } else if indexPath.section == TOP_BUFFER_SECTION {
                // do nothing
                
            } else {
                if indexPath.section % 2 == 0 {
                    cell.label!.hidden = true
                } else {

                    let model = self.scheduleModels[indexPath.section - TOP_BUFFER_SECTION - 1][0]
                    let date = model.time
                    cell.label!.text = model.fetchTime(date)
                    // reposition label to top of cell
                    cell.label!.frame.origin.y -= cell.frame.size.height / 2
                }

            }
        } else if indexPath.section == 0 {
            if indexPath.item > TITLE_CELL {
            
                let model = self.scheduleModels[0][indexPath.item - 1]
                let date = model.day
                cell.label!.text = model.fetchDay(date)
                cell.label!.textAlignment = .Center

            }
        } else if indexPath.section == ALL_DAY_SECTION {
            // define attributes for ALL_DAY_SECTION
            cell.backgroundColor = UIColor.lightGrayColor()
            
        } else if indexPath.section == TOP_BUFFER_SECTION {
            // do nothing
            
        } else {
            
            let BOTTOM_BUFFER_SECTION = TOP_BUFFER_SECTION + DISPLAY_TIME_CELLS + 1
            
            let colorIndex = (indexPath.section - TOP_BUFFER_SECTION - 1) * (DAY_CELLS) + (indexPath.item - 1)
            
            if indexPath.section == BOTTOM_BUFFER_SECTION {
                // do nothing
                
            } else {
                
                let section = indexPath.section - TOP_BUFFER_SECTION - 1
                let item = indexPath.item - 1
                let model = self.scheduleModels[section][item]
                cell.day = model.day
                cell.time = model.time
                
                
                cell.backgroundColor = self.scheduleModels[section][item].fetchColor(self.detailView.userModels.count)
                
                
                
                
//                let section = indexPath.section - TOP_BUFFER_SECTION - 1
//                let item = indexPath.item - 1
//                let day = dayFormatter.stringFromDate(model.day)
//                let time = timeFormatter.stringFromDate(model.time)
//                cell.label!.text = "D:(\(item))\(day)/T:(\(section))\(time)"

                
                if indexPath.section % 4 == 0 {
                    
                    
                } else if indexPath.section % 4 == 2 {
                    
                }
                
            }
        }
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == VRScheduleViewTopBorder.viewKindIdentifier {
            return self.collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: VRScheduleViewTopBorder.viewReuseIdentifier, forIndexPath: indexPath) as! VRScheduleViewTopBorder
        } else if kind == VRScheduleViewRightBorder.viewKindIdentifier {
            return self.collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: VRScheduleViewRightBorder.viewReuseIdentifier, forIndexPath: indexPath) as! VRScheduleViewRightBorder
        } else if kind == VRScheduleViewLeftBorder.viewKindIdentifier {
            return self.collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: VRScheduleViewLeftBorder.viewReuseIdentifier, forIndexPath: indexPath) as! VRScheduleViewLeftBorder
        }
        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DISPLAY_DAY_CELLS + 1
    }
  public   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return TOP_BUFFER_SECTION + DISPLAY_TIME_CELLS + ALL_DAY_SECTION + 1
    }
}

// MARK: - Select Cell Function

extension VRScheduleViewController: UICollectionViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item >= 1 && indexPath.section >= TOP_BUFFER_SECTION + ALL_DAY_SECTION && indexPath.section <= TOP_BUFFER_SECTION + DISPLAY_TIME_CELLS {
            
            if !isLandscape {
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    
                    self.updateBlur()
                    print("not landscape")
                    self.detailView.alpha = (self.detailView.alpha == 0) ? 1 : 0
                    
                    }, completion: {
                        (value: Bool) in
                        
                })
            }
            
            
            let itemIndex = indexPath.item - 1
            let sectionIndex = indexPath.section - TOP_BUFFER_SECTION - ALL_DAY_SECTION
            let detailViewItemIndex = itemIndex * TIME_CELLS + sectionIndex
            let detailViewIndexPath = NSIndexPath(forItem: detailViewItemIndex, inSection: 0)
            self.detailView.collectionView.scrollToItemAtIndexPath(detailViewIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
            
        } else {
            print("out of range")
        }
    }
}




// MARK: - Gesture Recognizer Functions

extension VRScheduleViewController {
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        let pinchPoint = sender.locationInView(self.collectionView)
        

        
        if pinchRecognizer.state == .Began {
            
            self.collectionView.scrollEnabled = false
            
        } else if pinchRecognizer.state == .Changed {
            // Resize according to scale
            print(sender.scale)
            var newScale = sender.scale - 1.0
            // constrain size of newScale
            if newScale < 0.0 {
                newScale = (newScale < -0.5) ? -0.5 : newScale
            } else {
                newScale = (newScale > 0.5) ? 0.5 : newScale
            }
            self.resizeCollectionView(newScale)
            
            let pressPoint = sender.locationInView(self.collectionView)
            if let indexPath = self.collectionView.indexPathForItemAtPoint(pressPoint) {
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
            }

            
        } else if pinchRecognizer.state == .Ended {
            
            self.collectionView.scrollEnabled = true

        }
        
    }
    
    func resizeCollectionView(newScale: CGFloat) {
        //            print("SCALE: \(sender.scale)")
        //            print("MAX_HEIGHT: \(self.collectionViewLayout.MAX_CELL_HEIGHT)")
        //            print("MIN_HEIGHT: \(self.collectionViewLayout.MIN_CELL_HEIGHT)")
        //            print("MAX_WIDTH: \(self.collectionViewLayout.MAX_CELL_WIDTH)")
        //            print("MIN_WIDTH: \(self.collectionViewLayout.MIN_CELL_WIDTH)")
        //            print("HEIGHT_FACTOR: \(self.collectionViewLayout.CELL_HEIGHT_FACTOR)")
        //            print("WIDTH_FACTOR: \(self.collectionViewLayout.CELL_WIDTH_FACTOR)")
        
        if newScale != 0 {
            let newCellHeight = self.collectionViewLayout.CELL_HEIGHT + newScale * self.collectionViewLayout.CELL_HEIGHT_FACTOR
            let maxCellHeight = self.collectionViewLayout.MAX_CELL_HEIGHT
            let minCellHeight = self.collectionViewLayout.MIN_CELL_HEIGHT
            let newCellWidth = self.collectionViewLayout.CELL_WIDTH + newScale * self.collectionViewLayout.CELL_WIDTH_FACTOR
            let maxCellWidth = self.collectionViewLayout.MAX_CELL_WIDTH
            let minCellWidth = self.collectionViewLayout.MIN_CELL_WIDTH
            
            //                print("HEIGHT: \(newCellHeight)")
            //                print("WIDTH: \(newCellWidth)")
            
            
            if (newCellHeight <= maxCellHeight && newCellHeight >= minCellHeight) {
                print("NEWSCALE: \(newScale)")
                self.collectionViewLayout.heightScale = newScale * self.collectionViewLayout.CELL_HEIGHT_FACTOR
                collectionViewLayout.dataSourceDidUpdate = true
            } else {
                self.collectionViewLayout.heightScale = 0
                
                if abs(newCellHeight - maxCellHeight) > abs(newCellHeight - minCellHeight) {
                    self.collectionViewLayout.CELL_HEIGHT = minCellHeight
                } else {
                    self.collectionViewLayout.CELL_HEIGHT = maxCellHeight
                }
            }
            
            if (newCellWidth <= maxCellWidth && newCellWidth >= minCellWidth) {
                self.collectionViewLayout.widthScale = newScale * self.collectionViewLayout.CELL_WIDTH_FACTOR
                collectionViewLayout.dataSourceDidUpdate = true
            } else {
                self.collectionViewLayout.widthScale = 0
                
                if abs(newCellWidth - maxCellWidth) > abs(newCellWidth - minCellWidth) {
                    self.collectionViewLayout.CELL_WIDTH = minCellWidth
                } else {
                    self.collectionViewLayout.CELL_WIDTH = maxCellWidth
                }
                
            }
            print("/////////")
            print(minCellHeight)
            print(self.collectionViewLayout.CELL_HEIGHT)
            print(minCellWidth)
            print(self.collectionViewLayout.CELL_WIDTH)
            
            collectionViewLayout.invalidateLayout()
            
        }
        
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        // get cell for longPress position
        let pressPoint = sender.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(pressPoint)
        if indexPath!.section > TOP_BUFFER_SECTION {
            
            let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! CollectionViewCell
            
            scheduleView.frame.size.width = cell.frame.size.width - CGFloat(SCHEDULE_VIEW_PADDING) * 2
            scheduleView.frame.size.height = cell.frame.size.height - CGFloat(SCHEDULE_VIEW_PADDING) * 2
            
            // positioning the scheduleView
            scheduleView.frame.origin.x = cell.frame.origin.x + CGFloat(SCHEDULE_VIEW_PADDING)
            scheduleView.frame.origin.y = pressPoint.y - cell.frame.height / 2
        }
        
        
        
        if sender.state == .Began {
            self.collectionView.scrollEnabled = false
            
            scheduleView.layer.shadowColor = UIColor.blackColor().CGColor
            scheduleView.hidden = false
            
        } else if sender.state == .Changed {
            
        } else if sender.state == .Ended {
            self.collectionView.scrollEnabled = true
            
            scheduleView.layer.shadowColor = UIColor.clearColor().CGColor
            scheduleView.hidden = true
            
            if isCalendar {
                self.presentViewController(self.eventNavigationController, animated: true, completion: nil)
            }

        }
        
        print("long touch")
    }
    
    func handleBlurTap(sender: UITapGestureRecognizer) {
        
        if sender.numberOfTouches() == 1 {
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                
                self.blurEffectView.alpha = 0
                self.detailView.alpha = 0
                }, completion: { (Bool) -> Void in
            })
        } else if sender.numberOfTouches() == 2 {
            print("Tapped twice")
        }
    }
    
    func updateBlur() {
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                
                self.blurEffectView.alpha = 1
                }, completion: { (Bool) -> Void in
            })
        }
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
    }
    
}


// MARK: - Why do we need this????

extension VRScheduleViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    

}



// MARK: - Check when orientation changes

extension VRScheduleViewController {
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            self.isLandscape = true
            if self.detailView.alpha == 0 {
                self.detailView.alpha = 1
            }
            if self.blurEffectView.alpha == 1 {
                self.blurEffectView.alpha = 0
            }
            
            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                
                self.collectionView.frame.size.height = UIScreen.mainScreen().bounds.width
                self.collectionView.frame.size.width = UIScreen.mainScreen().bounds.height / 2
                self.collectionView.frame.origin.y = 0

                }, completion: nil)
            
            
            self.detailView.center = CGPoint(x: UIScreen.mainScreen().bounds.height * (3.0 / 4.0), y: (UIScreen.mainScreen().bounds.width) / 2)


        } else {
            self.isLandscape = false
            if self.detailView.alpha == 1 {
                self.detailView.alpha = 0
            }

            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                
                self.collectionView.frame.size.height = UIScreen.mainScreen().bounds.width
                self.collectionView.frame.size.width = UIScreen.mainScreen().bounds.height
                self.collectionView.frame.origin.y = self.statusBarHeight

                }, completion: nil)
            
            self.detailView.center = CGPoint(x: UIScreen.mainScreen().bounds.height / 2, y: UIScreen.mainScreen().bounds.width/2)


        }
    }
}



// MARK: - Event Creation Controller Buttons

extension VRScheduleViewController {
    
    public func cancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    public func saveButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}



