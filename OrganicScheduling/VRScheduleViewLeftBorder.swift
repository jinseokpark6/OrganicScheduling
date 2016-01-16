//
//  VRScheduleViewLeftBorder.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/15/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

class VRScheduleViewLeftBorder: UICollectionReusableView {
    static let viewKindIdentifier = "VRScheduleViewLeftBorder"
    static let viewReuseIdentifier = "VRScheduleViewLeftBorder"
    
    
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
        self.shapeLayer.strokeColor = VRScheduleCellBorder.Left.colorValue.CGColor
        self.shapeLayer.lineWidth = VRScheduleCellBorder.Left.floatValue
    }
    
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? CollectionViewLayoutAttributes {
            //            self.lineStartTop = attributes.connectorLineStartTop
        }
    }
    
    override func layoutSubviews() {
        var start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        var end = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        self.shapeLayer.path = path.CGPath
        
        
    }
    

}
