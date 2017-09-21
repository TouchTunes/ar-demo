//
//  SceneView+ARSCNViewDelegate.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import ARKit

extension SceneViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        DispatchQueue.main.async {
            if self.enableDetectionSwitch.isOn {
                if (time - self.lastInferenceTime > self.kInferencePeriod) {
                    self.lastInferenceTime = time
                    if let currentFrame = self.sceneView.session.currentFrame {
                        let ciImage = CIImage(cvPixelBuffer: currentFrame.capturedImage)
                        self.touchTunesJukeDetector.setInputImage(image: ciImage)
                    }
                }
            }
        }

        DispatchQueue.main.async {
            if self.drawFeaturePointsSwitch.isOn {
                self.startDrawing()
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if self.drawHorizontalPlanesSwitch.isOn {
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
                self.addHorizontalPlane(node: node, for: planeAnchor)
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if self.drawHorizontalPlanesSwitch.isOn {
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
                self.updateHorizontalPlane(node: node, for: planeAnchor)
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if self.drawHorizontalPlanesSwitch.isOn {
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
                self.removeHorizontalPlane(node: node, for: planeAnchor)
            }
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {

    }
}
