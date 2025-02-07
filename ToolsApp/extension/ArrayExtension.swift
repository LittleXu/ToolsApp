//
//  ArrayExtension.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/27.
//

import UIKit
import ImageIO
import UniformTypeIdentifiers

extension Array where Element: UIImage {
    func generateGif() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "Error generating GIF", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get documents directory"])
        }
        
        let gifURL = documentsDirectory.appendingPathComponent("generated.gif")
        let destination = CGImageDestinationCreateWithURL(gifURL as CFURL, UTType.gif.identifier as CFString, self.count, nil)!
        
        let properties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        CGImageDestinationSetProperties(destination, properties as CFDictionary)
        
        for image in self {
            if let cgImage = image.cgImage {
                let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: 0.1]]
                CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
            }
        }
        
        if !CGImageDestinationFinalize(destination) {
            throw NSError(domain: "Error generating GIF", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to finalize GIF"])
        }
        
//        let gifData = try Data(contentsOf: gifURL)
////        try FileManager.default.removeItem(at: gifURL)
//        return gifData
        return gifURL
    }
}
