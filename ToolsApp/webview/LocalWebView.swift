//
//  LocalWebView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/2/7.
//

import Foundation
import UIKit
import WebKit
import SwiftUI


struct LocalWebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let htmlPath: String
    let title: String
    var body: some View {
        _LocalWebView(htmlPath: htmlPath)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text(title)
                }
                .foregroundColor(.black)
            }))
    }
}

#Preview {
    NavigationView(content: {
        LocalWebView(htmlPath: Bundle.main.path(forResource: "eula", ofType: "html")!, title: "用户协议")
    })
}



struct _LocalWebView: UIViewRepresentable {
    let htmlPath: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = URL(filePath: htmlPath)
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
       
    }
}
