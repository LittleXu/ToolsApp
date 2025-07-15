//
//  WaterMaskView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/21.
//

import Foundation
import SwiftUI

struct WaterMaskView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var sourceImage: UIImage?
    @State var resultImage: UIImage?
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSaveImage = false
    @State private var showImagePicker = false
    
    var body: some View {
        
        List {
            Section {
                VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    if sourceImage == nil {
                        Image(systemName: "plus.app")
                            .frame(width: 100, height: 100)
                            .font(.system(size: 44))
                    } else {
                        Image(uiImage: sourceImage!)
                            .resizable()
                            .scaledToFit()
                    }
                })
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.showImagePicker = true
                }
            } header: {
                Text("请选择带有水印的图片")
                    .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
            }
            
            if let resultImage = resultImage {
                Section {
                    VStack(alignment: .center, spacing: nil, content: {
                        Image(uiImage: resultImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                    })
                    .onLongPressGesture {
                        self.showSaveImage = true
                    }
                    .frame(maxWidth: .infinity)
                } footer: {
                    Text("长按保存图片")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            Section {
                Button {
                    guard let sourceImage = sourceImage else {
                        showError = true
                        errorMessage = "请选择带有水印的图片!"
                        return
                    }
                    
                    resultImage = Common.removeWatermark(from: sourceImage, watermarkFrame: CGRectMake(sourceImage.size.width - 400, sourceImage.size.height - 180, 400, 180))
                   
                } label: {
                    Text("去水印")
                }
                .foregroundColor(.blue)
                .frame(height: 44)
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("图片去水印")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $sourceImage, sourceType: .photoLibrary, allowsEditing: false)
        }
        .actionSheet(isPresented: $showSaveImage, content: {
            ActionSheet(title: Text("提示"), message: nil, buttons: [
                ActionSheet.Button.default(Text("保存到相册"), action: {
                    UIImageWriteToSavedPhotosAlbum(self.resultImage!, nil, nil, nil)
                    self.errorMessage = "保存成功!"
                    self.showError = true
                }),
                ActionSheet.Button.cancel()
            ])
        })
    }
}


#Preview {
    NavigationView(content: {
        WaterMaskView()
    })
}


