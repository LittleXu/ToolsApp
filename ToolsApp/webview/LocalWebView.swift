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





struct LocalWebView: UIViewRepresentable {
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
