//
//  VRNode.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/30/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

public class VRNode: Hashable, Equatable {
    
    let name: String
    
    enum NodeType: CustomStringConvertible {
        case Normal
        case Important
        case Critical
        
        var nodeColors: (label:UIColor, background: UIColor) {
            switch(self) {
            case .Normal:
                return (label:UIColor.blackColor(), background:UIColor.lightGrayColor())
            case .Important:
                return (label:UIColor.blackColor(), background:UIColor.yellowColor())
            case .Critical:
                return (label:UIColor.blackColor(), background:UIColor.redColor())
            }
        }
        var description: String {
            switch(self) {
            case .Normal:
                return "Normal"
            case .Important:
                return "Important"
            case .Critical:
                return "Critical"
            }
        }
    }
    let nodeType: NodeType
    var parent: VRNode?
    var children = Set<VRNode>()
    
    public var hashValue: Int {
        return self.name.hashValue ^ self.nodeType.hashValue
    }
    
    
    
    init(name: String, nodeType: NodeType) {
        self.name = name
        self.nodeType = nodeType
    }
    
}


public func ==(lhs: VRNode, rhs: VRNode) -> Bool {
    return lhs.name == rhs.name && lhs.nodeType == rhs.nodeType
}
