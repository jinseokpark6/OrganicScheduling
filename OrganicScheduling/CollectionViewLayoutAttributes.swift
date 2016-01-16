//
//  CollectionViewLayoutAttributes.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/31/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var backgroundColor: UIColor = UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: 1.0)
    
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! CollectionViewLayoutAttributes
//        copy.connectorLineStartTop = self.connectorLineStartTop
        return copy
    }
    
}
