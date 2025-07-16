//
//  CameraViewModel.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/15.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var capturedImage: UIImage? = nil
    
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    
    override init() {
        super.init()
//        DispatchQueue.global().async { [weak self] in
//            guard let self = self else { return }
            self.setupSession()
//        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("无法访问摄像头")
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    // 保存照片到相册
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("照片处理失败")
            return
        }
        
        DispatchQueue.main.async {
            if let flipped = image.flipImageHorizontally()?.cropToSquare() {
                self.capturedImage = flipped
            }
        }
        
        //        PHPhotoLibrary.requestAuthorization { status in
        //            if status == .authorized {
        //                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //                print("已保存到相册")
        //            } else {
        //                print("未授权相册访问")
        //            }
        //        }
    }
}


extension UIImage {
    // 将图片处理成正方形
    func cropToSquare() -> UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        
        let squareLength = min(originalWidth, originalHeight)
        let xOffset = (originalWidth - squareLength) / 2.0
        let yOffset = (originalHeight - squareLength) / 2.0
        
        let cropRect = CGRect(x: xOffset, y: yOffset, width: squareLength, height: squareLength)
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    // 将图片镜像(横向反转)
    func flipImageHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width, y: 0)
        context.scaleBy(x: -1.0, y: 1.0)
        draw(at: .zero)
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
}
