//
//  SceneViewSetup.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation
import ARKit

extension SceneViewController {

    internal func setupScene() {
        self.sceneView.setup()
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
        self.sceneView.session = ARSession()

        DispatchQueue.main.async {
            self.screenCenter = self.sceneView.bounds.mid
        }
    }

    internal func setupDebugUI() {
        self.restartTrackingButton.setTitle(" Restart AR Tracking ", for: .normal)
        self.restartTrackingButton.layer.cornerRadius = 10

        self.enableDetectionSwitch.isOn = false
        self.enableDetectionLabel.text = "Enable Jukebox Detection"

        self.enableDebugFeaturePointsSwitch.isOn = false
        self.enableDebugFeaturePointsLabel.text = "Enable Debug Feature Points"

        self.drawFeaturePointsSwitch.isOn = false
        self.drawFeaturePointsLabel.text = "Draw Feature Points"

        self.drawHorizontalPlanesSwitch.isOn = false
        self.drawHorizontalPlanesLabel.text = "Draw Horizontal Planes"

        self.showDebugOptionsButton.setTitle("Show Debug Options", for: .normal)
        self.showDebugOptionsButton.layer.cornerRadius = 10

        self.hideDetectionDebugSection()

        self.isShowingDebugOptions = true
        self.showDebugOptions(show: true)

        self.drawFeaturePointsAim.isHidden = !self.drawFeaturePointsSwitch.isOn

        self.placeObjectSwitch.isOn = false
        self.placeObjectLabel.text = "Place Object"
    }

    private func showDebugLabel(show: Bool) {
        if show {
            self.debugLabel.text = "That's a Jukebox!!"
            self.debugLabel.textColor = UIColor.blue
        } else {
            self.debugLabel.text = "NOT a Jukebox!!"
            self.debugLabel.textColor = UIColor.red
        }

        self.debugLabel.isHidden = !self.enableDetectionSwitch.isOn
        self.debugLabelView.isHidden = !self.enableDetectionSwitch.isOn
        self.debugLabelBackgroundView.isHidden = !self.enableDetectionSwitch.isOn
    }

    internal func showSuccessDebugLabel() {
        self.showDebugLabel(show: true)
    }

    internal func hideSuccessDebugLabel() {
        self.showDebugLabel(show: false)
    }

    internal func hideDetectionDebugSection() {
        self.debugLabel.isHidden = true
        self.debugLabelView.isHidden = true
        self.debugLabelBackgroundView.isHidden = true
    }

    internal func showDebugOptions(show: Bool) {
        self.showDebugOptionsButton.setTitle(show ? "Hide Debug Options" : "Show Debug Options", for: .normal)

        self.restartTrackingButton.isHidden = !show
        self.placeObjectSwitch.isHidden = !show
        self.placeObjectLabel.isHidden = !show

        self.enableDetectionSwitch.isHidden = !show
        self.enableDetectionLabel.isHidden = !show

        self.enableDebugFeaturePointsSwitch.isHidden = !show
        self.enableDebugFeaturePointsLabel.isHidden = !show

        self.drawFeaturePointsSwitch.isHidden = !show
        self.drawFeaturePointsLabel.isHidden = !show

        self.drawHorizontalPlanesSwitch.isHidden = !show
        self.drawHorizontalPlanesLabel.isHidden = !show
    }
}
