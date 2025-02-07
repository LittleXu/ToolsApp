//
//  PhotoBrowser.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/23.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct PhotoBrowserItemView: View {
    let url: URL
    let selected: Bool
    var body: some View {
        GeometryReader(content: { geometry in
        ZStack {
                KFImage(url)
                    .resizable()
                    .placeholder { _ in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    .cancelOnDisappear(true)
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

struct PhotoBrowser: View {
    
    let urls: [URL]
    
    @State private var selectedUrls: [URL] = []
    
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
                    ForEach(urls, id: \.self) { url in
                        PhotoBrowserItemView(url: url, selected: selectedUrls.contains(url))
                            .frame(width: geometry.size.width / 3.0 - 8, height: geometry.size.width / 3.0 - 8)
                            .background(Color.init(white: 0.85))
                            .cornerRadius(5.0)
                            .onTapGesture {
                                if selectedUrls.contains(url) {
                                    selectedUrls.removeAll { $0 == url}
                                } else {
                                    selectedUrls.append(url)
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
                if selectedUrls.count == urls.count {
                    selectedUrls.removeAll()
                } else {
                    selectedUrls = urls
                }
            }, label: {
                Text(selectedUrls.count == urls.count ? "取消" : "全选")
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
        
        guard !selectedUrls.isEmpty else {
            showError = true
            errorMessage = "请选择要保存的图片!"
            return
        }
        
        showLoading = true
        let group = DispatchGroup()
        
        for url in selectedUrls {
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    let image = value.image
                    Common.saveImageToPhotos(image) {
                        group.leave()
                    }
                case .failure(let error):
                    print("Error downloading image: \(error)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            showError = true
            errorMessage = "已保存到相册!"
            showLoading = false
        }
    }
}

#Preview {
    
    NavigationView(content: {
        PhotoBrowser(urls: [
            "http://gips2.baidu.com/it/u=1674525583,3037683813&fm=3028&app=3028&f=JPEG&fmt=auto?w=1024&h=1024",
            "http://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960",
            "http://gips2.baidu.com/it/u=844435709,4181700723&fm=3028&app=3028&f=JPEG&fmt=auto?w=960&h=1280",
            "http://gips3.baidu.com/it/u=100751361,1567855012&fm=3028&app=3028&f=JPEG&fmt=auto?w=960&h=1280",
            "http://gips0.baidu.com/it/u=2298867753,3464105574&fm=3028&app=3028&f=JPEG&fmt=auto?w=960&h=1280",
            "http://gips3.baidu.com/it/u=1821127123,1149655687&fm=3028&app=3028&f=JPEG&fmt=auto?w=720&h=1280",
        ].map {URL(string: $0)!})
    })
}


