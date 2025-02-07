//
//  BrowerView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/22.
//

import SwiftUI
import UIKit
import WebKit

struct BrowerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let urlString: String
    let type: BrowerType
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var webView: WKWebView?
    @State private var html: String?
    
    @State private var showBrowser = false
    
    @State private var urls: [String] = []
    
    var body: some View {
        return WebView(url: URL(string: urlString)!, webView: $webView, htmlContent: $html)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("")
                }
                .foregroundColor(.black)
            }))
            .navigationBarItems(trailing: Button(action: {
                if type == .screenshot {
                    screenshot()
                } else {
                    extractImages()
                }
                
            }, label: {
                Text(type.buttonTitle())
                Image(systemName: type.buttonImageName())
                NavigationLink(destination: PhotoBrowser(urls: urls.map { URL(string: $0)! }),
                    isActive: $showBrowser,
                    label: {
                        EmptyView()
                    })
            }))
            .alert(isPresented: $showError) {
                Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
            }
    }
    
    func screenshot() {
        if let webView = self.webView {
            webView.takeScreenshotOfFullContent { image in
                if let image = image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                self.errorMessage = "保存成功!"
                self.showError = true
            }
        }
    }
    
    // 提取图片
    func extractImages() {
        if let webView = self.webView, let html = self.html {
            var urls = webView.parseHTML(html: html)
            urls = urls.filter {$0.hasPrefix("http") }
            // 数组去重
            urls = Array(Set(urls))
            self.urls = urls
            self.showBrowser = true
        }
    }
}

#Preview {
    NavigationView(content: {
        BrowerView(urlString: "https://image.baidu.com/", type: .extractImages)
    })
}
