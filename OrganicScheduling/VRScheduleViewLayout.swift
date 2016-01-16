//
//  VRScheduleViewLayout.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/24/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//



import UIKit



public class VRScheduleViewLayout: UICollectionViewLayout {
    
    
//    var mainCalendar = CollectionViewController()

    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<NSIndexPath, [UICollectionViewLayoutAttributes]>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = false

    
    // Used to determine whether a layer of "ALL DAY" should be included or not
    var includeAllDay = true
    
    // MARK: - Update Scale of Cells
    var heightScale: CGFloat = 0
    var widthScale: CGFloat = 0
    
    public var DATE_HEIGHT: CGFloat = VRScheduleCellAttributes.DateHeight.floatValue
    public var TOP_BUFFER_HEIGHT: CGFloat = VRScheduleCellAttributes.TopBufferHeight.floatValue
    public var BOTTOM_BUFFER_HEIGHT: CGFloat = VRScheduleCellAttributes.BottomBufferHeight.floatValue
    public var TIME_WIDTH: CGFloat = VRScheduleCellAttributes.TimeWidth.floatValue
    
    public var LEFT_BORDER_WIDTH: CGFloat = VRScheduleCellBorder.Left.floatValue
    public var RIGHT_BORDER_WIDTH: CGFloat = VRScheduleCellBorder.Right.floatValue
    public var TOP_BORDER_WIDTH: CGFloat = VRScheduleCellBorder.Top.floatValue

    
    public var MAX_CELL_HEIGHT: CGFloat
    public var MAX_CELL_WIDTH: CGFloat
    public var MIN_CELL_HEIGHT: CGFloat
    public var MIN_CELL_WIDTH: CGFloat
    public var CELL_HEIGHT_FACTOR: CGFloat
    public var CELL_WIDTH_FACTOR: CGFloat


    
    var CELL_HEIGHT: CGFloat
    var CELL_WIDTH: CGFloat

    let STATUS_BAR: CGFloat = UIApplication.sharedApplication().statusBarFrame.height

    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    public var ALL_DAY_HEIGHT: CGFloat
    
    public var NUM_DAYS: Int
    public var NUM_TIMES: Int
    public var TOP_BUFFER_SECTION: Int
    
    public var eventCellZIndex: Int
    public var dayCellZIndex: Int
    public var timeCellCount: Int
    public var timeCellZIndexes: [Int]
    public var allDayCellZIndex: Int
    public var allDayTopCellZIndex: Int
    public var titleCellZIndex: Int
    
    public var isLandscape: Bool
    public var isInitialize: Bool

    
    
    override init() {
        
        CELL_HEIGHT = CGFloat()
        CELL_WIDTH = CGFloat()
        
        MAX_CELL_HEIGHT = CGFloat()
        MAX_CELL_WIDTH = CGFloat()
        MIN_CELL_HEIGHT = CGFloat()
        MIN_CELL_WIDTH = CGFloat()
        CELL_HEIGHT_FACTOR = CGFloat()
        CELL_WIDTH_FACTOR = CGFloat()

        
        NUM_TIMES = 48
        isLandscape = true
        isInitialize = true

        NUM_DAYS = 7

        TOP_BUFFER_SECTION = 2
        
        ALL_DAY_HEIGHT = (includeAllDay) ? 20.0 : 0.0

        eventCellZIndex = 1
        dayCellZIndex = 2
        
        timeCellCount = NUM_TIMES + TOP_BUFFER_SECTION
        timeCellZIndexes = [Int]()
        for i in 0...timeCellCount {
            timeCellZIndexes.append(Int(i + dayCellZIndex))
        }
        allDayCellZIndex = dayCellZIndex + timeCellCount + 1
        allDayTopCellZIndex = allDayCellZIndex + 1
        titleCellZIndex = allDayTopCellZIndex + 1
        
        
        super.init()
        
    }
    
    public init(isLandscape: Bool, isInitialize: Bool, NUM_TIMES: Int) {
        
        CELL_HEIGHT = CGFloat()
        CELL_WIDTH = CGFloat()
        
        MAX_CELL_HEIGHT = CGFloat()
        MAX_CELL_WIDTH = CGFloat()
        MIN_CELL_HEIGHT = CGFloat()
        MIN_CELL_WIDTH = CGFloat()
        CELL_HEIGHT_FACTOR = CGFloat()
        CELL_WIDTH_FACTOR = CGFloat()


        self.isLandscape = isLandscape
        self.isInitialize = isInitialize
        self.NUM_TIMES = NUM_TIMES


        NUM_DAYS = 7
        
        TOP_BUFFER_SECTION = 2
        
        ALL_DAY_HEIGHT = (includeAllDay) ? 20.0 : 0.0
        
        eventCellZIndex = 1
        dayCellZIndex = 2
        
        timeCellCount = NUM_TIMES + TOP_BUFFER_SECTION
        timeCellZIndexes = [Int]()
        for i in 0...timeCellCount {
            timeCellZIndexes.append(Int(i + dayCellZIndex))
        }
        allDayCellZIndex = dayCellZIndex + timeCellCount + 1
        allDayTopCellZIndex = allDayCellZIndex + 1
        titleCellZIndex = allDayTopCellZIndex + 1
        


        
        super.init()
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override public func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override public func prepareLayout() {
        



        if isInitialize {
            print(isInitialize)

            self.initializeLayout()
            
            // Acknowledge initialize, and disable for next time.
            isInitialize = false
            return
        }
        
        
        if !dataSourceDidUpdate {
            /* UPDATE HEADER */
            self.updateHeader()
            
        } else {
            
            print("datasource")
            
            self.updateHeader()
            self.updateLayout()
            
            // Acknowledge initialize, and disable for next time.
            dataSourceDidUpdate = false
        }

        


    }
    
    
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            for attributes in cellAttributes {
                if CGRectIntersectsRect(rect, attributes.frame) {
                    attributesInRect.append(attributes)
                }
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]![0]
    }
    
    public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]![1]
    }
    
    public override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == VRScheduleViewRightBorder.viewKindIdentifier {
            print("I'M HERE!!!!")
        }
        return nil
    }

    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let cv = self.collectionView {
            let lastVisibleItem = cv.visibleCells().last
            var proposedContentOffsetCenterX = proposedContentOffset.x
            if let lastVisibleItem = lastVisibleItem {
                
                // if scrolled to the end of the collectionView
                if proposedContentOffsetCenterX + cv.frame.width >= cv.contentSize.width {
                    // do nothing
                    
                    
                } else {
                    // reposition to the nearest cell
                    let itemWidth = lastVisibleItem.frame.size.width
                    let remainder = proposedContentOffset.x % itemWidth
                    if remainder >= itemWidth/2 {
                        proposedContentOffsetCenterX += (itemWidth - remainder)
                    } else {
                        proposedContentOffsetCenterX -= (remainder)
                    }
                }
            }
            return CGPoint(x: (proposedContentOffsetCenterX), y: proposedContentOffset.y)
        }
        
        // Fallback
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
        
        
    }
    
}

extension VRScheduleViewLayout {
    
    func initializeLayout() {
        
        MIN_CELL_HEIGHT = ( (collectionView!.bounds.size.height - CGFloat(DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT + BOTTOM_BUFFER_HEIGHT)) / CGFloat(NUM_TIMES) )
        MIN_CELL_WIDTH = ( (collectionView!.bounds.size.width - CGFloat(TIME_WIDTH)) / CGFloat(NUM_DAYS) )
        MAX_CELL_HEIGHT = ( (collectionView!.bounds.size.height - CGFloat(DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT + BOTTOM_BUFFER_HEIGHT)) / 6.0 )
        MAX_CELL_WIDTH = ( (collectionView!.bounds.size.width - CGFloat(TIME_WIDTH)) / 3.0 )
        CELL_HEIGHT_FACTOR = (MAX_CELL_HEIGHT - MIN_CELL_HEIGHT) / 30.0
        CELL_WIDTH_FACTOR = (MAX_CELL_WIDTH - MIN_CELL_WIDTH) / 30.0
        
        CELL_HEIGHT = MIN_CELL_HEIGHT
        CELL_WIDTH = MIN_CELL_WIDTH

        print(CELL_HEIGHT)
        print(CELL_WIDTH)

        
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                        
                        // Build the UICollectionViewLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
                        
                        var attributes = [UICollectionViewLayoutAttributes]()
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndex)
                        let bottomAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: VRScheduleViewTopBorder.viewKindIdentifier, withIndexPath: cellIndex)
                        let leftSideAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: VRScheduleViewLeftBorder.viewKindIdentifier, withIndexPath: cellIndex)
                        let rightSideAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: VRScheduleViewRightBorder.viewKindIdentifier, withIndexPath: cellIndex)
                        
                        //                        let rightSideAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: CollectionViewRightBorder.viewKindIdentifier, withIndexPath: cellIndex)
                        
                        
                        var xPos:CGFloat = 0.0
                        var yPos:CGFloat = 0.0
                        
                        if section == 0 && item == 0 {
                            xPos = 0
                            yPos = 0
                            cellAttributes.frame.size = CGSize(width: TIME_WIDTH, height: DATE_HEIGHT)
                            
                        } else if section == 0 {
                            xPos = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                            yPos = 0
                            cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: DATE_HEIGHT)
                        } else if section == 1 {
                            if item == 0 {
                                xPos = 0
                                yPos = DATE_HEIGHT
                                cellAttributes.frame.size = CGSize(width: TIME_WIDTH, height: ALL_DAY_HEIGHT)
                            } else {
                                xPos = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                                yPos = DATE_HEIGHT
                                cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: ALL_DAY_HEIGHT)
                            }
                            
                        } else if section == 2  {
                            
                            // DEFINE TOP_BUFFER
                            
                            if item == 0 {
                                xPos = 0
                                yPos = DATE_HEIGHT + ALL_DAY_HEIGHT
                                cellAttributes.frame.size = CGSize(width: TIME_WIDTH, height: TOP_BUFFER_HEIGHT)
                            } else {
                                xPos = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                                yPos = DATE_HEIGHT + ALL_DAY_HEIGHT
                                cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: TOP_BUFFER_HEIGHT)
                                bottomAttributes.frame.size = CGSize(width: CELL_WIDTH, height: TOP_BORDER_WIDTH)
                                bottomAttributes.frame.origin = CGPoint(x: xPos, y: yPos + TOP_BUFFER_HEIGHT - TOP_BORDER_WIDTH)
                            }
                            
                        } else if item == 0 {
                            xPos = 0
                            yPos = CGFloat(section - 3) * CELL_HEIGHT + DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT
                            cellAttributes.frame.size = CGSize(width: TIME_WIDTH, height: CELL_HEIGHT)
                            
                            
                        } else {
                            
                            xPos = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                            yPos = CGFloat(section - 3) * CELL_HEIGHT + DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT
                            
                            let BOTTOM_BUFFER_SECTION = collectionView!.numberOfSections() - 1
                            
                            if section == BOTTOM_BUFFER_SECTION {
                                
                                // DEFINE BOTTOM_BUFFER
                                
                                if item == 0 {
                                    cellAttributes.frame.size = CGSize(width: TIME_WIDTH, height: TOP_BUFFER_HEIGHT)
                                } else {
                                    cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: TOP_BUFFER_HEIGHT)
                                }
                                
                            } else {
                                if item == 1 {
                                    // add left border
                                    leftSideAttributes.frame.size = CGSize(width: LEFT_BORDER_WIDTH, height: CELL_HEIGHT)
                                    leftSideAttributes.frame.origin = CGPoint(x: xPos - LEFT_BORDER_WIDTH, y: yPos)
                                }
                                
                                cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
                                bottomAttributes.frame.size = CGSize(width: CELL_WIDTH, height: TOP_BORDER_WIDTH)
                                rightSideAttributes.frame.size = CGSize(width: RIGHT_BORDER_WIDTH, height: CELL_HEIGHT)
                                bottomAttributes.frame.origin = CGPoint(x: xPos, y: yPos + CELL_HEIGHT - TOP_BORDER_WIDTH)
                                rightSideAttributes.frame.origin = CGPoint(x: xPos + CELL_WIDTH - RIGHT_BORDER_WIDTH, y: yPos)
                            }
                            
                        }
                        cellAttributes.frame.origin = CGPoint(x: xPos, y: yPos)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = titleCellZIndex
                        } else if section == 1 && item == 0 {
                            cellAttributes.zIndex = allDayTopCellZIndex
                        } else if section == 1 {
                            cellAttributes.zIndex = allDayCellZIndex
                        } else if item == 0 {
                            cellAttributes.zIndex = timeCellZIndexes[section - 1]
                        } else if section == 0 {
                            cellAttributes.zIndex = dayCellZIndex
                        } else {
                            cellAttributes.zIndex = eventCellZIndex
                        }
                        
                        attributes.append(cellAttributes)
                        attributes.append(bottomAttributes)
                        attributes.append(rightSideAttributes)
                        attributes.append(leftSideAttributes)
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = attributes
                        
                    }
                }
            }
        }
        
        // Update content size.
        let contentWidth = CGFloat(collectionView!.numberOfItemsInSection(0) - 1) * CELL_WIDTH + TIME_WIDTH
        let contentHeight = CGFloat(collectionView!.numberOfSections() - 4) * CELL_HEIGHT + DATE_HEIGHT + ALL_DAY_HEIGHT + TOP_BUFFER_HEIGHT + BOTTOM_BUFFER_HEIGHT
        self.contentSize = CGSize(width: contentWidth + 1, height: contentHeight + 1)

    }
    
    func updateHeader() {
        
        // Determine current content offsets.
        let xOffset = collectionView!.contentOffset.x
        let yOffset = collectionView!.contentOffset.y
        
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Confirm the section has items.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    
                    // Update all items in the first row.
                    if section == 0 {
                        for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                            
                            // Build indexPath to get attributes from dictionary.
                            let indexPath = NSIndexPath(forItem: item, inSection: section)
                            
                            // Update y-position to follow user.
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var cellFrame = attrs[0].frame
                                // Also update x-position for corner cell.
                                if item == 0 {
                                    cellFrame.origin.x = xOffset
                                }
                                
                                cellFrame.origin.y = yOffset
                                attrs[0].frame = cellFrame
                            }
                            
                        }
                    } else if section == 1 {
                        for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                            
                            let indexPath = NSIndexPath(forItem: item, inSection: section)
                            
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var cellFrame = attrs[0].frame
                                // Also update x-position for corner cell.
                                if item == 0 {
                                    cellFrame.origin.x = xOffset
                                }
                                
                                cellFrame.origin.y = yOffset + DATE_HEIGHT
                                attrs[0].frame = cellFrame
                            }
                        }
                    }
                        // For all other sections, we only need to update
                        // the x-position for the first item.
                    else {
                        
                        // Build indexPath to get attributes from dictionary.
                        let indexPath = NSIndexPath(forItem: 0, inSection: section)
                        
                        // Update y-position to follow user.
                        if let attrs = cellAttrsDictionary[indexPath] {
                            var cellFrame = attrs[0].frame
                            cellFrame.origin.x = xOffset
                            attrs[0].frame = cellFrame
                        }
                    }
                }
            }
        }
        // Do not run attribute generation code
        // unless data source has been updated.
        return
    }
    
    func updateLayout() {
     
        

        
        CELL_HEIGHT += heightScale
        CELL_WIDTH += widthScale
        
        
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections() > 0 {
            for section in 0...collectionView!.numberOfSections()-1 {
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    for item in 0...collectionView!.numberOfItemsInSection(section)-1 {
                        
                        // Build the UICollectionViewLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
                        
                        var xPos:CGFloat = 0.0
                        var yPos:CGFloat = 0.0
                        
                        if section == 0 && item == 0 {
                            // do nothing

                        } else if section == 0 {
                            cellAttrsDictionary[cellIndex]![0].frame.origin.x = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                            cellAttrsDictionary[cellIndex]![0].frame.size.width = CELL_WIDTH

                            // update day label position (SUN, MON, TUE...)
                            if let cell = self.collectionView?.cellForItemAtIndexPath(cellIndex) as? CollectionViewCell {
                                if let label = cell.label {
                                    label.center.x = CELL_WIDTH / 2.0
                                }
                            }
                            
                        } else if section == 1 {
                            if item == 0 {
                                // do nothing
                            } else {
                                cellAttrsDictionary[cellIndex]![0].frame.origin.x = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                                cellAttrsDictionary[cellIndex]![0].frame.size.width = CELL_WIDTH
                            }
                            
                        } else if section == 2  {
                            
                            // DEFINE TOP_BUFFER
                            if item == 0 {
                                // do nothing
                            } else {
                                cellAttrsDictionary[cellIndex]![0].frame.origin.x = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                                cellAttrsDictionary[cellIndex]![0].frame.size.width = CELL_WIDTH
                                cellAttrsDictionary[cellIndex]![1].frame.size.width = CELL_WIDTH
                                cellAttrsDictionary[cellIndex]![1].frame.origin.x = cellAttrsDictionary[cellIndex]![0].frame.origin.x
                            }
                            
                        } else if item == 0 {
                            cellAttrsDictionary[cellIndex]![0].frame.origin.y = CGFloat(section - 3) * CELL_HEIGHT + DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT
                            cellAttrsDictionary[cellIndex]![0].frame.size.height = CELL_HEIGHT
                            
                            
                        } else {
                            
                            xPos = CGFloat(item - 1) * CELL_WIDTH + TIME_WIDTH
                            yPos = CGFloat(section - 3) * CELL_HEIGHT + DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT
                            
                            let BOTTOM_BUFFER_SECTION = collectionView!.numberOfSections()-1
                            
                            if section == BOTTOM_BUFFER_SECTION {
                                
                                // DEFINE BOTTOM_BUFFER
                                
                                if item == 0 {
                                    // do nothing
                                } else {
                                    cellAttrsDictionary[cellIndex]![0].frame.size.width = CELL_WIDTH
                                    cellAttrsDictionary[cellIndex]![0].frame.origin.y = CGFloat(BOTTOM_BUFFER_SECTION - 3) * CELL_HEIGHT + DATE_HEIGHT + TOP_BUFFER_HEIGHT + ALL_DAY_HEIGHT
                                }
                                
                            } else {
                                if item == 1 {
                                    // add left border
                                    cellAttrsDictionary[cellIndex]![3].frame.size.height = CELL_HEIGHT
                                    cellAttrsDictionary[cellIndex]![3].frame.origin = CGPoint(x: xPos - LEFT_BORDER_WIDTH, y: yPos)
                                }
                                
                                cellAttrsDictionary[cellIndex]![0].frame.size = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
                                cellAttrsDictionary[cellIndex]![1].frame.size.width = CELL_WIDTH
                                cellAttrsDictionary[cellIndex]![2].frame.size.height = CELL_HEIGHT
                                
                                cellAttrsDictionary[cellIndex]![0].frame.origin = CGPoint(x: xPos, y: yPos)
                                cellAttrsDictionary[cellIndex]![1].frame.origin = CGPoint(x: xPos, y: yPos + CELL_HEIGHT - TOP_BORDER_WIDTH)
                                cellAttrsDictionary[cellIndex]![2].frame.origin = CGPoint(x: xPos + CELL_WIDTH - RIGHT_BORDER_WIDTH, y: yPos)
                            }
                        }
                    }
                }
            }
        }
        // Update content size.
        let contentWidth = CGFloat(collectionView!.numberOfItemsInSection(0) - 1) * CELL_WIDTH + TIME_WIDTH
        let contentHeight = CGFloat(collectionView!.numberOfSections() - 4) * CELL_HEIGHT + DATE_HEIGHT + ALL_DAY_HEIGHT + TOP_BUFFER_HEIGHT + BOTTOM_BUFFER_HEIGHT
        self.contentSize = CGSize(width: contentWidth + 1, height: contentHeight + 1)
   
    }
}
