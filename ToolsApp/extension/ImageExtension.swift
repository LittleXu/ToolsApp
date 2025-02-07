//
//  ImageExtension.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/27.
//

import Foundation
import UIKit
import ImageIO

extension UIImage {
    
    var memorySize: Int {
        guard let cgImage = cgImage else { return 0 }
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let bytesPerRow = cgImage.bytesPerRow
        let imageSize = cgImage.width * cgImage.height * bytesPerPixel
        
        return imageSize + bytesPerRow
    }
    
    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return UIImage.animatedImageWithSource(source)
    }

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var duration: TimeInterval = 0.0

        for index in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
                duration += UIImage.frameDurationAtIndex(index, source: source)
            }
        }

        return UIImage.animatedImage(with: images.map { UIImage(cgImage: $0) }, duration: duration)
    }

    class func frameDurationAtIndex(_ index: Int, source: CGImageSource) -> TimeInterval {
        var frameDuration: TimeInterval = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)

        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                to: AnyObject.self)
        }

        frameDuration = delayObject as? TimeInterval ?? 0.1

        if frameDuration < 0.011 {
            frameDuration = 0.1
        }

        return frameDuration
    }
}
