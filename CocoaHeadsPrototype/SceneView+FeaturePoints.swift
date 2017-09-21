//
//  SceneView+FeaturePoints.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension SceneViewController {

    func startDrawing() {
        guard let screenCenter = self.screenCenter else { return }

        let hitTestResults = sceneView.hitTest(screenCenter, types: .featurePoint)
        if let result = hitTestResults.first {
            let position = SCNVector3(result.worldTransform.translation)
            let sphere = SphereNode(position: position, distance: result.distance)
            sceneView.scene.rootNode.addChildNode(sphere)
        }
    }

    func worldPositionFromScreenPosition(_ position: CGPoint,
                                         in sceneView: ARSCNView,
                                         objectPos: float3?,
                                         infinitePlane: Bool = false) -> (position: float3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {

        let planeHitTestResults = sceneView.hitTest(position, types: .featurePoint)
        if let result = planeHitTestResults.first {

            let planeHitTestPosition = result.worldTransform.translation
            let planeAnchor = result.anchor

            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }

        return (nil, nil, false)
    }
}
