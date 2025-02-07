//
//  LocalPhotoBrowser.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/23.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct LocalPhotoBrowserItemView: View {
    let image: UIImage
    let selected: Bool
    var body: some View {
        GeometryReader(content: { geometry in
        ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Image(systemName: selected ? "checkmark.circle.fill" : "checkmark.circle")
                .foregroundColor(selected ? .blue : .gray)
                    .offset(x: geometry.size.width / 2 - 15, y: -geometry.size.width / 2 + 15)
            }
        })
        
    }
}

struct LocalPhotoBrowser: View {
    
    let images: [UIImage]
    
    @State private var selectedImages: [UIImage] = []
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showLoading = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                LazyVGrid(columns: columns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5, pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/, content: {
                    ForEach(images, id: \.self) { image in
                        
                        LocalPhotoBrowserItemView(image: image, selected: selectedImages.contains(image))
                            .frame(width: geometry.size.width / 3.0 - 8, height: geometry.size.width / 3.0 - 8)
                            .background(Color.init(white: 0.85))
                            .cornerRadius(5.0)
                            .onTapGesture {
                                if selectedImages.contains(image) {
                                    selectedImages.removeAll { $0 == image }
                                } else {
                                    selectedImages.append(image)
                                }
                            }
                    }
                })
            }
        })

        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("选择")
            }
            .foregroundColor(.black)
        }))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                if selectedImages.count == images.count {
                    selectedImages.removeAll()
                } else {
                    selectedImages = images
                }
            }, label: {
                Text(selectedImages.count == images.count ? "取消" : "全选")
            })
            
            if showLoading {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
                    .foregroundColor(.blue)
                    .frame(width: 50)
            } else {
                Button(action: {
                    saveImages()
                }, label: {
                    Text("保存")
                })
            }
        })
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
    }
    
    func saveImages() {
        
        guard !selectedImages.isEmpty else {
            showError = true
            errorMessage = "请选择要保存的图片!"
            return
        }
        
        showLoading = true
        let group = DispatchGroup()
        
        for image in selectedImages {
            saveImageToPhotos(image) {}
        }
        
        group.notify(queue: .main) {
            showError = true
            errorMessage = "已保存到相册!"
            showLoading = false
        }
    }
    
    func saveImageToPhotos(_ image: UIImage, completion: @escaping () -> Void) {
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



