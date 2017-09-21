//
//  CIImage+Conversion.swift
//  CocoaHeadsPrototype
//
//  Created by Vesselin Petkov on 2017-08-29.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit

extension CIImage {
    func newPixelBuffer(height: CGFloat, width: CGFloat) -> CVPixelBuffer? {
        let cicontext = CIContext(options: nil)
        
        let cgImage = cicontext.createCGImage(self, from:self.extent)
        
        let options: [String: Any] = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
        var pxbuffer: CVPixelBuffer?
        
        let frameWidth = width
        let frameHeight = height
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameWidth), Int(frameHeight), kCVPixelFormatType_32ARGB, options as CFDictionary?, &pxbuffer)
        assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let cgcontext = CGContext(data: pxdata, width: Int(frameWidth), height: Int(frameHeight), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        assert(cgcontext != nil, "context is nil")
        
        cgcontext!.concatenate(CGAffineTransform.identity)
        cgcontext!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxbuffer
    }
}
