//
//  QRCodeView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/17.
//

import SwiftUI
import UIKit


struct QRCodeView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State var link: String = ""
    @State var editedImage: UIImage?
    @State var resultImage: UIImage?
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var showImagePicker = false
    @State private var showSaveImage = false
    
    var body: some View {
        
        List {
            
            Section {
                HStack {
                    TextField("请输入文字", text: $link)
                        .frame(height: 44)
                }
                .frame(height: 44)
                
                HStack {
                    Text("请选择图片(可选)")
                        .foregroundColor(.gray)
                    Spacer()
                    if let image = editedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .cornerRadius(5)
                            .clipped() // 避免超出视图范围
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 44)
                .onTapGesture {
                    self.showImagePicker = true
                }
            } footer: {
                Text("如果选择了图片, 则会在二维码中间生成该图片")
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
            
            if let resultImage = resultImage {
                Section {
                    VStack(alignment: .center, spacing: nil, content: {
                        Image(uiImage: resultImage)
                            .frame(width: 200, height: 200)
                            .onLongPressGesture {
                                self.showSaveImage = true
                            }
                    })
                    .frame(maxWidth: .infinity)
                } footer: {
                    Text("长按保存二维码")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            Section {
                Button {
                    
                    UIApplication.shared.endEditing(true)
                    
                    guard !link.isEmpty else {
                        self.errorMessage = "请输入文字"
                        self.showError = true
                        return
                    }
                     
                    if let image = Common.qrcode(with: link) {
                        if let logo = self.editedImage {
                            let imageWidthLogo = Common.generateImageWithOverlay(background: image, overlay: logo)
                            self.resultImage = imageWidthLogo
                            
                        } else {
                            self.resultImage = image
                        }
                    } else {
                        self.errorMessage = "生成二维码失败!"
                        self.showError = true
                    }
                    
                } label: {
                    Text("生成二维码")
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
                Text("生成二维码")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $editedImage, sourceType: .photoLibrary, allowsEditing: true)
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
       QRCodeView()
    })
}

