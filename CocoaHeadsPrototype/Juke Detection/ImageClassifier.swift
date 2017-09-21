//
//  ImageClassifierDelegate.swift
//  CocoaHeadsPrototype
//
//  Created by Vesselin Petkov on 2017-08-29.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol ImageClassifierDelegate : class {
    func imageClassified(image: CIImage, results: [VNClassificationObservation])
}

class ImageClassifier: NSObject {
    weak var delegate: ImageClassifierDelegate?
    
    internal var coreModel: VNCoreMLModel
    
    init(coreModel: VNCoreMLModel) {
        self.coreModel = coreModel
    }
    
    public func detectScene(image: CIImage) {
        let sizedPixelBuffer = image.newPixelBuffer(height: 299.0, width: 299.0)
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: coreModel) { [weak self] request, error in
            let results = request.results as? [VNClassificationObservation]
            self?.delegate?.imageClassified(image: image, results: results!)
        }
        
        // Run the Core ML
        let handler = VNImageRequestHandler(cvPixelBuffer: sizedPixelBuffer!, options: [:])
        DispatchQueue(label: "inference queue", qos: .utility).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
