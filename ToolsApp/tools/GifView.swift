//
//  GifView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/28.
//

import SwiftUI
import WebKit

struct GifView: View {
    let url: URL
    var body: some View {
        GifWebView(url: url)
    }
}
 
struct GifWebView: UIViewRepresentable {
    let url: URL?
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let gifURL = url else { return }
        let request = URLRequest(url: gifURL)
        uiView.load(request)
    }
}


struct LimitHeightGifView: View {
    let path: String
    var body: some View {
        let html = """
                <html>
                <head>
                    <style>
                        body {
                            margin: 0;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            background-color: #ffffff;
                        }
                        img {
                            width: auto;
                            height: 160px;
                        }
                    </style>
                </head>
                <body>
                    <img src="\(path)" alt="GIF">
                </body>
                </html>
                """
        LimitHeightGifWebView(htmlString: html)
    }
}



struct LimitHeightGifWebView: UIViewRepresentable {
    let htmlString: String
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false // 禁用滚动
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}


#Preview {
    VStack {
        GifView(url: URL(filePath: Bundle.main.path(forResource: "durian", ofType: "gif")!))
        LimitHeightGifView(path: Bundle.main.path(forResource: "durian", ofType: "gif")!)
    }
   
}
