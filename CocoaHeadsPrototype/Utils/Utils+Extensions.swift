//
//  UIExtensions.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia on 2017-08-28.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import ARKit

extension ARSCNView {
    func setup() {
        self.antialiasingMode = .multisampling4X
        self.automaticallyUpdatesLighting = false

        self.preferredFramesPerSecond = 60
        self.contentScaleFactor = 1.0

        if let camera = self.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset   = 0
            camera.minimumExposure  = 0
            camera.maximumExposure  = 0
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3

        return float3(translation.x, translation.y, translation.z)
    }
}

extension CGRect {
    var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
