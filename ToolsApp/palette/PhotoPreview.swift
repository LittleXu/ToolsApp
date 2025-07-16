//
//  PhotoPreview.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/16.
//

import Foundation
import SwiftUI

struct PreviewView: View {
    var image: UIImage
    var onRetake: () -> Void
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var displayedImage: UIImage
    @State private var selectedFilter: String = "Original"
    
    let filters: [(name: String, filterName: String?)] = [
        ("原图", nil),
        ("黑白高对比", "CIPhotoEffectNoir"),
        ("柔和单色", "CIPhotoEffectMono"),
        ("复古棕色", "CISepiaTone"),
        ("褪色梦幻", "CIPhotoEffectFade"),
        ("胶片彩色", "CIPhotoEffectChrome"),
        ("即时怀旧", "CIPhotoEffectInstant"),
        ("艺术调色", "CIPhotoEffectTransfer"),
        ("流行色彩", "CIPhotoEffectProcess"),
        ("灰调柔化", "CIPhotoEffectTonal"),
        ("颜色反转", "CIColorInvert")
    ]
    
    init(image: UIImage, onRetake: @escaping () -> Void) {
          self.image = image
          self.onRetake = onRetake
          _displayedImage = State(initialValue: image)
      }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                Image(uiImage: displayedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height * 0.65)
                    .clipped()
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filters, id: \.name) { filter in
                            Button(action: {
                                if let filterName = filter.filterName,
                                   let filtered = image.applyFilter(name: filterName) {
                                    displayedImage = filtered
                                } else {
                                    displayedImage = image
                                }
                                selectedFilter = filter.name
                            }) {
                                Text(filter.name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedFilter == filter.name ? Color.blue.opacity(0.6) : Color.black.opacity(0.4))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .background(Color.black.opacity(0.25))
                .clipShape(Capsule())
                .padding(.horizontal, 30)
                .padding(.bottom, 15)
                
                HStack(spacing: 40) {
                    
                    Button(action: {
                        onRetake()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    
                    Button(action: {
                        Common.saveImageToPhotos(displayedImage) {
                            errorMessage = "已保存至相册!"
                            showError = true
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    
                    Button(action: {
                        onRetake()
                    }) {
                        Image(systemName: "camera.rotate")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                }
                .padding(.bottom, 20)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .alert(isPresented: $showError) {
            Alert(title: Text(""), message: Text(errorMessage), dismissButton: .default(Text("好的")))
        }
    }
}

#Preview {
    PreviewView(image: UIImage(named: "logo")!) {}
}


extension UIImage {
    func applyFilter(name: String) -> UIImage? {
        let context = CIContext()
        guard let ciImage = CIImage(image: self),
              let filter = CIFilter(name: name) else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
