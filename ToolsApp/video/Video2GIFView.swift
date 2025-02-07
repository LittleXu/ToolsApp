//
//  Video2GIFView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/17.
//

import SwiftUI
import UIKit
import AVKit
import PhotosUI


struct Video2GIFView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var videoURL: URL?
    @State private var gifImageUrl: URL?

    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showVideoPicker = false
    @State private var showSaveImage = false
    
    
    @State private var showPhotoBrowser = false
    @State private var images: [UIImage] = []

    
    @State private var showLoading = false
    @State private var isConverting = false
    @State private var player: AVPlayer?

    var body: some View {
        
        List {
            Section {
                HStack {
                    if videoURL != nil {
                        VideoPlayer(player: player)
                            .frame(height: 300)
                            .onAppear(perform: {
                                player = AVPlayer(url: videoURL!)
                                player?.play()
                                showLoading = false
                            })
                            .onDisappear(perform: {
                                player?.pause()
                            })
                        
                    } else {
                        Text("请选择视频")
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: (videoURL == nil ? 44 : 300))
                .onTapGesture {
                    self.showVideoPicker = true
                    self.showLoading = true
                }
            } footer: {
                HStack {
                    if showLoading {
                        ActivityIndicator(isAnimating: $showLoading, style: .medium)
                        Text("视频加载中...")
                    } else {
                        Text("视频大小可能会影响转换的速度")
                    }
                }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
            
            if let gifImageUrl = gifImageUrl {
                Section {
                    VStack(alignment: .center, spacing: nil, content: {
                        GifView(url: gifImageUrl)
                            .frame(height: 240)
//                        .onLongPressGesture {
//                                self.showSaveImage = true
//                            }
                    })
                    .frame(maxWidth: .infinity)
                } footer: {
                    Text("长按保存GIF")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            Section {
                Button {
                    UIApplication.shared.endEditing(true)
                    guard videoURL != nil else {
                        self.errorMessage = "请选择视频"
                        self.showError = true
                        return
                    }
                    isConverting = true
                    extractFrames(from: videoURL!, completion: { images in
                        if let url = try? images.generateGif() {
                            self.gifImageUrl = url
                        }
                    })
                } label: {
                    Text("视频转GIF")
                }
                .foregroundColor(.blue)
                .frame(height: 44)
            } footer: {
                if isConverting {
                    HStack {
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        Text("转换中...")
                    }
                }
            }
            
        }
        .onChange(of: videoURL) { oldValue, newValue in
            if let newValue = newValue {
                if player != nil {
                    player?.pause()
                    player = nil
                    player = AVPlayer(url: newValue)
                    player?.play()
                    showLoading = false
                }
            }
        }
        
        .onChange(of: gifImageUrl, { oldValue, newValue in
            if isConverting {
                isConverting = false
            }
        })
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("视频转GIF")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker(selectedURL: $videoURL)
        }
        .sheet(isPresented: $showPhotoBrowser, content: {
            NavigationView(content: {
                LocalPhotoBrowser(images: images)
            })
        })
//        .actionSheet(isPresented: $showSaveImage, content: {
//            ActionSheet(title: Text("提示"), message: nil, buttons: [
//                ActionSheet.Button.default(Text("保存到相册"), action: {
//                    saveGifToPhotos()
//                }),
//                ActionSheet.Button.cancel()
//            ])
//        })
    }
    
    
//    func saveGifToPhotos() {
//        PHPhotoLibrary.shared().performChanges {
//            let createRequest = PHAssetCreationRequest.forAsset()
//            createRequest.addResource(with: .photo, fileURL: gifImageUrl!, options: nil)
//        } completionHandler: { success, error in
//            if success {
//                self.errorMessage = "保存成功!"
//                self.showError = true
//            } else if let error = error {
//                self.errorMessage = "保存失败!"
//                self.showError = true
//            }
//        }
//    }
    
    func extractFrames(from videoURL: URL, completion: B1<[UIImage]>?) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.maximumSize = CGSize(width: 240, height: 240) // 设置最大尺寸
        imageGenerator.appliesPreferredTrackTransform = true // 应用视频的旋转信息
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero

        var frames = [UIImage]()
        let duration = asset.duration.seconds
        let totalFrames = Int(duration * 10) // Capture 10 frames per second
        var times: [NSValue] = []
        for i in 0..<totalFrames {
            let time = CMTime(seconds: Double(i) * (1.0 / 10.0), preferredTimescale: 600)
            times.append(NSValue(time: time))
        }
        var tempImages: [UIImage] = []
        var count = 0
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, result, _ in
            count += 1
            if let cgImage = image {
                tempImages.append(UIImage(cgImage: cgImage))
            }
            
            if count == times.count {
                completion?(tempImages)
            }
        }
    }
}

#Preview {
    NavigationView(content: {
        Video2GIFView()
    })
}

