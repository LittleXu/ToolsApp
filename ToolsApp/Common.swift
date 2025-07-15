//
//  Common.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/20.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins
import PhotosUI

typealias B = ()->Void
typealias B1<T> = (T)->Void
typealias B2<T1, T2> = (T1, T2)->Void
typealias B3<T1, T2, T3> = (T1, T2, T3)->Void

extension Common {
    static let aboutUsURL = "https://happy-fall-be3.notion.site/2833f76429294b24825a32a8efefa7d2?pvs=4"
    static let privacyURL = "https://happy-fall-be3.notion.site/17d82ca17933802cad97db3bcc3fde65?pvs=4"
}


extension Common {
    static func saveImageToPhotos(_ image: UIImage, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                print("Image saved to photo library.")
            } else if let error = error {
                print("Error saving image: \(error)")
            }
            completion()
        })
    }
}

extension Common {
    static func currentViewController() -> UIViewController? {
        var current: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while current != nil {
            let vc = current!
            if let tabbarvc = vc as? UITabBarController {
                current = tabbarvc.selectedViewController
            } else if let navc = vc as? UINavigationController {
                current = navc.topViewController
            }
            else if let presented = current?.presentedViewController {
                current = presented
            }
            else if let split = vc as? UISplitViewController, split.viewControllers.count > 0 {
                current = split.viewControllers.last
            } else {
                return current
            }
        }
        return current
    }
}


import CoreImage
import CoreImage.CIFilterBuiltins
struct Common {
    static func removeWatermark(from image: UIImage, watermarkFrame: CGRect) -> UIImage? {
        // Create a CIImage from the original UIImage
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // Create a mask image with the same size as the original image
        let maskSize = image.size
        UIGraphicsBeginImageContext(maskSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Fill the mask with black color
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(origin: .zero, size: maskSize))
        
        // Fill the watermark area with white color
        context.setFillColor(UIColor.white.cgColor)
        context.fill(watermarkFrame)
        
        // Get the mask image
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgMaskImage = maskImage?.cgImage else { return nil }
        
        // Create a CIImage from the mask image
        let maskCIImage = CIImage(cgImage: cgMaskImage)
        
        // Apply the mask to the original image
        guard let compositingFilter = CIFilter(name: "CIBlendWithMask") else { return nil }
        compositingFilter.setValue(ciImage, forKey: kCIInputImageKey)
        compositingFilter.setValue(maskCIImage, forKey: kCIInputMaskImageKey)
        
        // Get the output CIImage
        guard let outputCIImage = compositingFilter.outputImage else { return nil }
        
        // Convert the output CIImage to UIImage
        let contextCI = CIContext(options: nil)
        guard let cgImage = contextCI.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    static func generateBarcodeImage(barcode: String) -> UIImage {
        let data = barcode.data(using: .ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let outputImage = filter.outputImage {
                let context = CIContext()
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    static func qrcode(with url: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator", parameters: nil) else { return nil }
        guard let data = url.data(using: .utf8) else { return nil }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let image = filter.outputImage else { return nil }
        // 高清处理
        return Common.createHDImage(with: image, size: 200)
    }
    
    static func createHDImage(with image: CIImage, size: CGFloat) -> UIImage {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        
        let width: size_t = size_t(extent.width * scale)
        let height: size_t = size_t(extent.height * scale)
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
        
        ///
        let context = CIContext.init()
        let bitmapImage = context.createCGImage(image, from: extent)
        bitmap.interpolationQuality = .none
        bitmap.scaleBy(x: scale, y: scale)
        bitmap.draw(bitmapImage!, in: extent)
        let scaledImage = bitmap.makeImage()
        return UIImage.init(cgImage: scaledImage!)
    }
    
    
    static func addBorderToImage(image: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        let size = image.size
        let newSize = CGSize(width: size.width + 2 * borderWidth, height: size.height + 2 * borderWidth)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // 绘制边框
        borderColor.setFill()
        context?.fill(CGRect(origin: .zero, size: newSize))
        
        // 绘制图片
        image.draw(in: CGRect(x: borderWidth, y: borderWidth, width: size.width, height: size.height))
        
        // 获取合成后的图片
        let imageWithBorder = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithBorder
    }
    
    
    static func generateImageWithOverlay(background: UIImage, overlay: UIImage) -> UIImage {
        let size = background.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // 绘制背景图片
        background.draw(in: CGRect(origin: .zero, size: size))
        
        // 计算叠加图标的位置和大小
        let overlaySize = CGSize(width: size.width / 5, height: size.height / 5)
        let overlayOrigin = CGPoint(x: (size.width - overlaySize.width) / 2, y: (size.height - overlaySize.height) / 2)
        let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)
        
        // 绘制叠加图标
        overlay.draw(in: overlayRect)
        
        // 获取合成后的图片
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage!
    }
}
