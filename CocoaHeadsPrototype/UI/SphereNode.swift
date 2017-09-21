//
//  SphereNode.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia on 2017-09-05.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import SceneKit

class SphereNode: SCNNode {

    init(position: SCNVector3, distance: CGFloat) {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.0025)
        let material = SCNMaterial()

        material.diffuse.contents = UIColor(
            red: 255.0,
            green: supportedValue(originalValue: distance),
            blue: 0.0,
            alpha: 1.0)
        material.lightingModel = .constant
        sphereGeometry.materials = [material]
        self.geometry = sphereGeometry
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func supportedValue(originalValue: CGFloat) -> CGFloat {
        let positiveValue = originalValue < 0 ? -originalValue : originalValue
        let supportedValueToReturn = CGFloat(Int(positiveValue * 1000) % 255)

        print(supportedValueToReturn)
        
        return supportedValueToReturn
    }
}
