//
//  WebView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/22.
//

import SwiftUI
import WebKit
import SwiftSoup

struct WebView: UIViewRepresentable {
    let url: URL
    
    @Binding var webView: WKWebView?
    @Binding var htmlContent: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
       
    }
    
    func makeCoordinator() -> Coordinator {
          Coordinator(parent: self)
      }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.webView = webView
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { html, error in
                if let html = html as? String {
                    self.parent.htmlContent = html
                }
            }
        }
    }
}


/// WebViewPrintPageRenderer: use to print the full content of webview into one image
internal final class WebViewPrintPageRenderer: UIPrintPageRenderer {

    private var formatter: UIPrintFormatter

    private var contentSize: CGSize

    /// 生成PrintPageRenderer实例
    ///
    /// - Parameters:
    ///   - formatter: WebView的viewPrintFormatter
    ///   - contentSize: WebView的ContentSize
    required init(formatter: UIPrintFormatter, contentSize: CGSize) {
        self.formatter = formatter
        self.contentSize = contentSize
        super.init()
        self.addPrintFormatter(formatter, startingAtPageAt: 0)
    }

    override var paperRect: CGRect {
        return CGRect.init(origin: .zero, size: contentSize)
    }

    override var printableRect: CGRect {
        return CGRect.init(origin: .zero, size: contentSize)
    }

    private func printContentToPDFPage() -> CGPDFPage? {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, 1))
        let bounds = UIGraphicsGetPDFContextBounds()
        UIGraphicsBeginPDFPage()
        self.drawPage(at: 0, in: bounds)
        UIGraphicsEndPDFContext()

        let cfData = data as CFData
        guard let provider = CGDataProvider.init(data: cfData) else {
            return nil
        }
        let pdfDocument = CGPDFDocument.init(provider)
        let pdfPage = pdfDocument?.page(at: 1)

        return pdfPage
    }

    private func covertPDFPageToImage(_ pdfPage: CGPDFPage) -> UIImage? {
        let pageRect = pdfPage.getBoxRect(.trimBox)
        let contentSize = CGSize.init(width: floor(pageRect.size.width), height: floor(pageRect.size.height))

        // usually you want UIGraphicsBeginImageContextWithOptions last parameter to be 0.0 as this will us the device's scale
        UIGraphicsBeginImageContextWithOptions(contentSize, true, 2.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.white.cgColor)
        context.fill(pageRect)

        context.saveGState()
        context.translateBy(x: 0, y: contentSize.height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.interpolationQuality = .low
        context.setRenderingIntent(.defaultIntent)
        context.drawPDFPage(pdfPage)
        context.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    /// print the full content of webview into one image
    ///
    /// - Important: if the size of content is very large, then the size of image will be also very large
    /// - Returns: UIImage?
    internal func printContentToImage() -> UIImage? {
        guard let pdfPage = self.printContentToPDFPage() else {
            return nil
        }

        let image = self.covertPDFPageToImage(pdfPage)
        return image
    }
}

extension WKWebView {
    public func takeScreenshotOfFullContent(_ completion: @escaping ((UIImage?) -> Void)) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            let renderer = WebViewPrintPageRenderer.init(formatter: self.viewPrintFormatter(), contentSize: self.scrollView.contentSize)
            let image = renderer.printContentToImage()
            completion(image)
        }
    }
    
    public func parseHTML(html: String) -> [String] {
        do {
            let document = try SwiftSoup.parse(html)
            let imgElements = try document.select("img")
            
            var urls: [String] = []
            for img in imgElements {
                if let src = try? img.attr("src") {
                    urls.append(src)
                }
            }
            
            return urls
        } catch {
            print("Failed to parse HTML: \(error)")
            return []
        }
    }
}
