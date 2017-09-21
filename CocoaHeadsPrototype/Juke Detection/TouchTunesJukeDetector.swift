//
//  TouchTunesJukeDetector.swift
//  CocoaHeadsPrototype
//
//  Created by Vesselin Petkov on 2017-08-29.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import Vision

protocol TouchTunesJukeDetectorDelegate : class {
    func jukeDetected()
    func jukeNotDetected()
}

class TouchTunesJukeDetector: ImageClassifierDelegate {

    // MARK - Instance Variables
    private var imageClassifier: ImageClassifierJukebox!
    weak var delegate: TouchTunesJukeDetectorDelegate?

    // MARK: - Public Interface
    init() {
        self.imageClassifier = ImageClassifierJukebox()
        self.imageClassifier.delegate = self
    }

    public func setInputImage(image: CIImage) -> Swift.Void {
        self.imageClassifier.detectScene(image: image)
    }

    // MARK: - ImageClassifierDelegate
    func imageClassified(image: CIImage, results: [VNClassificationObservation]) {
        let firstResult = results.first

        let confidence: Float = firstResult!.confidence

        if firstResult?.identifier == "touchtunes" && confidence > 0.5 {
            self.delegate?.jukeDetected()
        } else {
            self.delegate?.jukeNotDetected()
        }
    }
}
