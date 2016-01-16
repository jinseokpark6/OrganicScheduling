//
//  CollectionViewHeader.swift
//  OrganicScheduling
//
//  Created by WUSTL STS on 12/31/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    static let viewKindIdentifier = "CollectionViewHeader"
    static let viewReuseIdentifier = "CollectionViewHeader"
    
    var lineStartTop: Bool = true
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    // MARK: - Initialize
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    func sharedInit() {
        self.opaque = true
        self.shapeLayer.fillColor = nil
        self.shapeLayer.strokeColor = VRScheduleCellBorder.Bottom.colorValue.CGColor
        self.shapeLayer.lineWidth = VRScheduleCellBorder.Bottom.floatValue
    }
    
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? CollectionViewLayoutAttributes {
//            self.lineStartTop = attributes.connectorLineStartTop
        }
    }

    override func layoutSubviews() {
        var start = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        var end = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)

//        if self.lineStartTop {
//            start.y = self.bounds.minY
//            end.y = self.bounds.maxY
//        }
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        self.shapeLayer.path = path.CGPath
        
//        print("path:\(self.shapeLayer.strokeEnd)")
        
    }
    
    
}
