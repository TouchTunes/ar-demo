//
//  Coin.swift
//  CocoaHeadsPrototype
//
//  Created by Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Coin: SCNNode {

    func update(at position: SCNVector3) {
        let scene = SCNScene(named: "art.scnassets/coin.scn")!
        let coinNode = scene.rootNode.childNode(withName: "coin", recursively: true)!
        
        coinNode.position = position
        
        let coinTransform = coinNode.transform
        
        let translation = SCNMatrix4MakeTranslation(-10, 0, -10)
        var newTransform = SCNMatrix4Mult(translation, coinTransform)
        
        let rotationTransform = SCNMatrix4MakeRotation(-.pi / 2.0, 1.0, 0.0, 0.0)
        newTransform = SCNMatrix4Mult(rotationTransform, newTransform)
        coinNode.transform = newTransform;
        
        self.centerPivot(for: coinNode)
        coinNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        addChildNode(coinNode)
    }
    
    func centerPivot(for node: SCNNode) {
        let (min, max) = node.boundingBox
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }
}
