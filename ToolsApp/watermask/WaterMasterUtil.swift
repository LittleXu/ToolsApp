////
////  WaterMasterUtil.swift
////  ToolsApp
////
////  Created by liuxu on 2024/5/21.
////
//
//import Foundation
//import CoreImage
//import UIKit
//
//
//struct Point: Hashable {
//    let x: Int
//    let y: Int
//}
//
//extension Common {
//    
//    // Function to automatically detect watermark region
//    static func detectWatermarkRegion(in image: UIImage) -> CGRect? {
//        guard let cgImage = image.cgImage else {
//            return nil
//        }
//        
//        let ciImage = CIImage(cgImage: cgImage)
//        
//        // Convert CIImage to grayscale
//        let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono")
//        grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//        
//        guard let grayscaleImage = grayscaleFilter?.outputImage else {
//            return nil
//        }
//        
//        // Apply edge detection
//        let edgesFilter = CIFilter(name: "CIEdges")
//        edgesFilter?.setValue(grayscaleImage, forKey: kCIInputImageKey)
//        edgesFilter?.setValue(5.0, forKey: kCIInputIntensityKey)
//        
//        guard let edgesImage = edgesFilter?.outputImage else {
//            return nil
//        }
//        
//        // Threshold the image to find bright regions (potential watermarks)
//        let thresholdFilter = CIFilter(name: "CIColorControls")
//        thresholdFilter?.setValue(edgesImage, forKey: kCIInputImageKey)
//        thresholdFilter?.setValue(1.0, forKey: kCIInputBrightnessKey)
//        thresholdFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
//        thresholdFilter?.setValue(1.1, forKey: kCIInputContrastKey)
//        
//        guard let thresholdedImage = thresholdFilter?.outputImage else {
//            return nil
//        }
//        
//        // Extract the largest bright region as the potential watermark
//        let context = CIContext(options: nil)
//        guard let thresholdedCGImage = context.createCGImage(thresholdedImage, from: thresholdedImage.extent) else {
//            return nil
//        }
//        
//        let inputImage = UIImage(cgImage: thresholdedCGImage)
//        guard let detectedRect = findLargestBrightRegion(in: inputImage) else {
//            return nil
//        }
//        
//        return detectedRect
//    }
//    
//    
//    // Helper function to find the largest bright region in the image
//    static func findLargestBrightRegion(in image: UIImage) -> CGRect? {
//        guard let cgImage = image.cgImage else {
//            return nil
//        }
//        
//        let pixelData = cgImage.dataProvider?.data
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//        
//        let width = cgImage.width
//        let height = cgImage.height
//        
//        var maxRect = CGRect.zero
//        var maxArea: CGFloat = 0
//        
//        for y in 0..<height {
//            for x in 0..<width {
//                let pixelIndex = ((width * y) + x) * 4
//                let brightness = data[pixelIndex] // As we used grayscale, R=G=B
//                
//                if brightness > 200 { // Threshold for bright regions
//                    let rect = findConnectedComponent(in: data, width: width, height: height, x: x, y: y, threshold: 200)
//                    let area = rect.width * rect.height
//                    if area > maxArea {
//                        maxArea = area
//                        maxRect = rect
//                    }
//                }
//            }
//        }
//        
//        return maxArea > 0 ? maxRect : nil
//    }
//
//    // Helper function to find the connected component of a bright region
//    static func findConnectedComponent(in data: UnsafePointer<UInt8>, width: Int, height: Int, x: Int, y: Int, threshold: UInt8) -> CGRect {
//        var minX = x
//        var minY = y
//        var maxX = x
//        var maxY = y
//        
//        var stack: [Point] = [Point(x: x, y: y)]
//        var visited: Set<Point> = [Point(x: x, y: y)]
//
//        while let point = stack.popLast() {
//            let cx = point.x
//            let cy = point.y
//            let pixelIndex = ((width * cy) + cx) * 4
//            let brightness = data[pixelIndex]
//            
//            if brightness >= threshold {
//                minX = min(minX, cx)
//                minY = min(minY, cy)
//                maxX = max(maxX, cx)
//                maxY = max(maxY, cy)
//                
//                for (nx, ny) in [(cx - 1, cy), (cx + 1, cy), (cx, cy - 1), (cx, cy + 1)] {
//                    let neighbor = Point(x: nx, y: ny)
//                    if nx >= 0, nx < width, ny >= 0, ny < height, !visited.contains(neighbor) {
//                        stack.append(neighbor)
//                        visited.insert(neighbor)
//                    }
//                }
//            }
//        }
//        
//        return CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
//    }
//
//    // Function to remove watermark from an image using detected region
//    static func removeWatermark(from image: UIImage) -> UIImage? {
//        guard let watermarkRect = detectWatermarkRegion(in: image) else {
//            return nil
//        }
//        return removeWatermark(from: image, watermarkRect: watermarkRect)
//    }
//}
