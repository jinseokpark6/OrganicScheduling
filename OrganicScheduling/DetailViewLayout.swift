//
//  DetailViewLayout.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/27/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public class DetailViewLayout: UICollectionViewLayout {
    
    
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
    var dataSourceDidUpdate = true
    

    
    
    override public func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    
    override public func prepareLayout() {
        
        // Used for calculating each cells CGRect on screen.
        // CGRect will define the Origin and Size of the cell.
        let HEADER_HEIGHT: CGFloat = 100.0
        let HEADER_WIDTH: CGFloat = collectionView!.bounds.size.width
        
        var CELL_HEIGHT: CGFloat = (collectionView!.bounds.size.height - HEADER_HEIGHT) / 5.0
        var CELL_WIDTH: CGFloat = collectionView!.bounds.size.width
        
        let EMPTY_CELL_HEIGHT: CGFloat = 0
        
        let STATUS_BAR = UIApplication.sharedApplication().statusBarFrame.height
        
        let TOP_BUFFER_SECTION = 2

        
        // Only update header cells.
        if !dataSourceDidUpdate {
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
                                    var frame = attrs[0].frame
                                    
                                    frame.origin.y = yOffset
                                    attrs[0].frame = frame
                                }
                                
                            }
                        }
                    }
                }
            }
            
            
            // Do not run attribute generation code
            // unless data source has been updated.
            return
        }
        
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        
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
                        let headerCellAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: DetailViewHeader.viewKindIdentifier, withIndexPath: cellIndex)

                        var xPos:CGFloat = 0.0
                        var yPos:CGFloat = 0.0
                        

                        
                        if section == 0 {
                            xPos = CGFloat(item) * HEADER_WIDTH
                            yPos = 0
                            cellAttributes.frame.size = CGSize(width: HEADER_WIDTH, height: HEADER_HEIGHT)
                        } else {
                            xPos = CGFloat(item) * CELL_WIDTH
                            yPos = CGFloat(section - 1) * CELL_HEIGHT + HEADER_HEIGHT
                            cellAttributes.frame.size = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
                        }
                        cellAttributes.frame.origin = CGPoint(x: xPos, y: yPos)
                        
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        attributes.append(cellAttributes)
                        
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = attributes
                        
                    }
                }
            }
        }
        
        // Update content size.
        let contentWidth = CELL_WIDTH * CGFloat((collectionView?.numberOfItemsInSection(0))!)
        var contentHeight = CGFloat(collectionView!.numberOfSections() - 1) * CELL_HEIGHT + HEADER_HEIGHT
        if contentHeight <= collectionView!.bounds.size.height {
            contentHeight = collectionView!.bounds.size.height + 1
        }
        self.contentSize = CGSize(width: contentWidth + 1, height: contentHeight)
        
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            for attribute in cellAttributes {
                if CGRectIntersectsRect(rect, attribute.frame) {
                    //                print(cellAttributes.frame)
                    attributesInRect.append(attribute)
                }
            }
        }

        // Return list of elements.
        return attributesInRect
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]![0]
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
//    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        print("currentOffsetX: \(collectionView?.contentOffset.x)")
//        print("proposedOffset: \(proposedContentOffset.x)")
////        print("velocity: \(velocity)")
//        let item = collectionView?.visibleCells().last
//        let itemWidth = item!.frame.size.width
//        print("itemWidth: \(itemWidth)")
//        let currentOffsetX = collectionView?.contentOffset.x
//        let currentRemainderX = currentOffsetX! % itemWidth
//        print("currentRemainderX: \(currentRemainderX)")
//        let adjustedOffsetX = (currentRemainderX > 0) ? currentOffsetX! + (itemWidth - currentRemainderX) : currentOffsetX! - currentRemainderX
//        print("adjustedOffsetX: \(adjustedOffsetX)")
//
////        let diffOffsetX = proposedContentOffset.x - adjustedOffsetX
////        print("DIFF: \(diffOffsetX)")
//        var newOffset = CGPoint()
//
////        if abs(diffOffsetX) > itemWidth {
////            if diffOffsetX > 0 {
////                newOffset.x = adjustedOffsetX + itemWidth
////            } else {
////                newOffset.x = adjustedOffsetX - itemWidth
////            }
////        } else {
////            if abs(diffOffsetX) > itemWidth / 2 {
////                if diffOffsetX > 0 {
////                    newOffset.x = adjustedOffsetX + itemWidth
////                } else {
////                    newOffset.x = adjustedOffsetX - itemWidth
////                }
////            } else {
////                newOffset.x = adjustedOffsetX
////            }
////        }
//        
//        newOffset.x = adjustedOffsetX
//        newOffset.y = proposedContentOffset.y
//
//        return newOffset
//
////        if let cv = self.collectionView {
////            let item = cv.visibleCells().last
////            var proposedContentOffsetCenterX = proposedContentOffset
////            if let item = item {
////                let itemWidth = item.frame.size.width
////                print("itemWidth: \(itemWidth)")
////                let remainder = proposedContentOffset.x % itemWidth
////                if remainder >= itemWidth/2 {
////                    proposedContentOffsetCenterX.x += (itemWidth - remainder)
////                } else {
////                    proposedContentOffsetCenterX.x -= (remainder)
////                }
////            }
////            return CGPoint(x: (proposedContentOffsetCenterX.x), y: proposedContentOffset.y)
////        }
//        
//        // Fallback
//        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
//        
//        
//    }
}



