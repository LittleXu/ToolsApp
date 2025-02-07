//
//  BarCodeView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/20.
//

import SwiftUI
import UIKit

struct BarCodeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var link: String = ""
    @State var resultImage: UIImage?
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSaveImage = false
    
    var body: some View {
        
        List {
            
            Section {
                HStack {
                    TextField("请输入文字", text: $link)
                        .frame(height: 44)
                }
                .frame(height: 44)
            }
            
            if let resultImage = resultImage {
                Section {
                    VStack(alignment: .center, spacing: nil, content: {
                        Image(uiImage: resultImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .onLongPressGesture {
                                self.showSaveImage = true
                            }
                    })
                    .frame(maxWidth: .infinity)
                } footer: {
                    Text("长按保存条形码")
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
                    
                    let image = Common.generateBarcodeImage(barcode: link)
                    self.resultImage = image
                } label: {
                    Text("生成条形码")
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
                Text("生成条形码")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
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
        BarCodeView()
    })
}
