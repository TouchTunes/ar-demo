//
//  SceneViewJukeboxDetector.swift
//  CocoaHeadsPrototype
//
//  Created by Juan Garcia and Shirag Berejikian on 2017-09-19.
//  Copyright © 2017 Touchtunes. All rights reserved.
//

import Foundation

extension SceneViewController: TouchTunesJukeDetectorDelegate {

    func jukeDetected() {
        self.resolveJukeDetected(true)
    }

    func jukeNotDetected() {
        self.resolveJukeDetected(false)
    }

    func resolveJukeDetected(_ status: Bool) {
        self.jukeDetectedBuffer.insert(status, at: 0)

        if (self.jukeDetectedBuffer.count > 10) {
            let numberOfTrue = self.jukeDetectedBuffer.filter{$0}.count
            let percentageOfTrue: Float = Float(numberOfTrue) / Float(self.jukeDetectedBuffer.count)
            let mostlyTrue: Bool = percentageOfTrue > 0.8
            self.jukeResolved(mostlyTrue)
            self.jukeDetectedBuffer.removeAll()
        }
    }

    func jukeResolved(_ status: Bool) {
        if (status && !self.jukeDetectedState) {
            self.jukeDetectedState = true;
            self.jukeDetectedTrueCount += 1

            DispatchQueue.main.async {
                self.showSuccessDebugLabel()
                if self.placeObjectSwitch.isOn {
                    self.addCoin()
                }
            }
        }
        else if (!status) {
            self.jukeDetectedState = false;

            DispatchQueue.main.async {
                self.hideSuccessDebugLabel()
            }
        }
    }
}
