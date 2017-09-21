//
//  ImageClassifierJukebox.swift
//  CocoaHeadsPrototype
//
//  Created by Vesselin Petkov on 2017-08-29.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import Vision

class ImageClassifierJukebox: ImageClassifier {
    init() {
        guard let model = try? VNCoreMLModel(for: inceptionv3jukeboxv2().model) else {
            fatalError("can't load ML model")
        }

        super.init(coreModel: model)
    }
}
