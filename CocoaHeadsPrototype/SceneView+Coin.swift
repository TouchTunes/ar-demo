//
//  SceneView+Coin.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import SceneKit

extension SceneViewController {

    func addCoin() {

        if (self.coinAdded || !self.jukeDetectedState) {
            return
        }

        if let middleFeaturePoint = self.findMiddleFeaturePoint() {
            if let unwrappedCoinNode = self.coinNode {
                unwrappedCoinNode.position = middleFeaturePoint
            }
            else {
                self.coinNode = Coin()
                self.coinNode?.update(at: middleFeaturePoint)
            }

            if self.coinNode != nil {
                DispatchQueue.main.async {
                    self.coinAdded = true
                    self.sceneView.scene.rootNode.addChildNode(self.coinNode!)
                }
            }
        }
    }

    func findMiddleFeaturePoint() -> SCNVector3? {
        var minMaxPoints = Array<SCNVector3>()

        var minX: Float = Float.greatestFiniteMagnitude, minY: Float = Float.greatestFiniteMagnitude, minZ: Float = Float.greatestFiniteMagnitude
        var maxX: Float = Float.leastNonzeroMagnitude, maxY: Float = Float.leastNonzeroMagnitude, maxZ: Float = Float.leastNonzeroMagnitude

        for _ in 0..<50 {
            if let rawFeaturePoints = self.sceneView.session.currentFrame?.rawFeaturePoints {
                for index in 0..<rawFeaturePoints.points.count {
                    if let points = self.sceneView.session.currentFrame?.rawFeaturePoints?.points {
                        let pointExists = points.indices.contains(index)
                        if pointExists {
                            let validPoint = points[index]

                            if validPoint.x < minX { minX = validPoint.x }
                            if validPoint.x > maxX { maxX = validPoint.x }

                            if validPoint.y < minY { minY = validPoint.y }
                            if validPoint.y > maxY { maxY = validPoint.y }

                            if validPoint.z < minZ { minZ = validPoint.z }
                            if validPoint.z > maxZ { maxZ = validPoint.z }
                        }
                    }

                    let newX: Float = minX + (maxX - minX) / 2
                    let newY: Float = minY + (maxY - minY) / 2
                    let newZ: Float = minZ + (maxZ - minZ) / 2

                    if newX > -100 && newX < 100 && newY > -100 && newY < 100 && newZ > -100 && newZ < 100 {
                        minMaxPoints.append(SCNVector3.init(newX, newY, newZ))
                    }
                }
            }
        }

        if minMaxPoints.count == 0 {
            return nil
        }

        guard let screenCenter = self.screenCenter else { return nil }

        let hitTestResults = sceneView.hitTest(screenCenter, types: .featurePoint)
        if let result = hitTestResults.first {
            let centerPosition = SCNVector3(result.worldTransform.translation)

            let xValue = (minMaxPoints.map({$0.x})).reduce(0) { $0 + $1 }
            let yValue = (minMaxPoints.map({$0.y})).reduce(0) { $0 + $1 }
            let zValue = (minMaxPoints.map({$0.z})).reduce(0) { $0 + $1 }

            let preCoinPosition = SCNVector3.init(xValue / Float(minMaxPoints.count), yValue / Float(minMaxPoints.count), zValue / Float(minMaxPoints.count))
            let finalPosition = SCNVector3.init(((centerPosition.x * 2) + preCoinPosition.x) / 3, ((centerPosition.y * 2) + preCoinPosition.y) / 3, ((centerPosition.z * 2) + preCoinPosition.z) / 3)

            return finalPosition
        }

        return nil
    }
}
