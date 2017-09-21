//
//  Plane.swift
//  CocoaHeadsPrototype
//
//  Created by Shirag Berejikian on 2017-09-14.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor?
    var planeGeometry: SCNPlane?

    func set(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        let img = UIImage(named: "tron_grid")
        material.diffuse.contents = img
        planeGeometry!.materials = [material]
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-.pi / 2.0, 1.0, 0.0, 0.0)
        setTextureScale()
        addChildNode(planeNode)
    }

    func update(with anchor: ARPlaneAnchor) {
        planeGeometry?.width = CGFloat(anchor.extent.x)
        planeGeometry?.height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        setTextureScale()
    }

    func setTextureScale() {
        if let material: SCNMaterial = planeGeometry!.materials.first {
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(planeGeometry!.width), Float(planeGeometry!.height), 1)
            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
        }
    }
}

