//
//  VRCalendarDataController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 12/30/15.
//  Copyright © 2015 jinseokpark. All rights reserved.
//

import UIKit

class VRCalendarDataController: NSObject {

    var nodes = Set<VRNode>()
    var sections = [[VRNode]]()
    var maxNodesInSection = 0
    
    func performFetch() {
        
        
        
//        let calendar = VRNode(name: "root", nodeType: .Normal) {
//            [
//                VRNode(name: "child 1", nodeType: .Normal) {
//                    [ VRNode(name: "child 1-1", nodeType: .Normal), VRNode(name: "child 1-2", nodeType: .Important)]
//                },
//                VRNode(name: "child 2", nodeType: .Normal),
//                VRNode(name: "child 3", nodeType: .Normal) {
//                    [
//                        VRNode(name: "child 3-1", nodeType: .Normal) {
//                            [ VRNode(name: "child 3-1-1", nodeType: .Critical), VRNode(name: "child 3-1-1", nodeType: .Critical)]
//                        },
//                        VRNode(name: "child 3-2", nodeType: .Important)
//
//                    ]
//                }
//            ]
//        }
    }
    
    func nodeAtIndexPath(indexPath: NSIndexPath) -> VRNode? {
//        if let section = self.sections.optionalElementAtIndex(indexPath.section) {
//            return section.optionalElementAtIndex(indexPath.row)
//        }
        return nil
    }
    
    func indexPathForNode(node: VRNode) -> NSIndexPath? {
        for (sectionIndex, section) in self.sections.enumerate() {
            for (itemIndex, item) in section.enumerate() {
                if node == item {
                    return NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
                }
            }
        }
        return nil
    }
    
}


