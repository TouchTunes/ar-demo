//
//  SceneView+Planes.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

extension SceneViewController {

    func clearHorizontalPlanes() {
        for (_, plane) in self.planes {
            plane.removeFromParentNode()

            let anchor: ARAnchor? = plane.anchor
            if (anchor != nil) {
                self.sceneView.session.remove(anchor: anchor!)
            }
        }

        self.planes.removeAll()
    }

    func addHorizontalPlane(node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        let planeNode = Plane()
        planeNode.set(anchor: planeAnchor)
        self.planes[planeAnchor.identifier] = planeNode

        node.addChildNode(planeNode)
    }

    func updateHorizontalPlane(node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        if let plane = self.planes[planeAnchor.identifier] {
            plane.update(with: planeAnchor)
        }
    }

    func removeHorizontalPlane(node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        let plane = self.planes[planeAnchor.identifier]
        plane?.removeFromParentNode()
    }
}
