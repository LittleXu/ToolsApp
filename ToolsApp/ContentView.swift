//
//  ContentView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/17.
//

import SwiftUI


struct ContentListView: View {
    
    let systemImageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .frame(width: 25)
            Text(text)
                .foregroundColor(.black)
        }.frame(height: 44)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    
                    
                    NavigationLink {
                        LEDBannerView()
                    } label: {
                        ContentListView(systemImageName: "light.beacon.max", text: "应援字幕机")
                    }
                    
                    NavigationLink {
                        PaletteView()
                    } label: {
                        ContentListView(systemImageName: "camera.aperture", text: "补色板")
                    }
                    
                    
                    
                } header: {
                    Text("新功能")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                Section {
                    NavigationLink {
                        AnswerBookView()
                    } label: {
                        ContentListView(systemImageName: "books.vertical", text: "答案之书")
                    }
                    
                    NavigationLink {
                        TurnTableListView()
                            .environmentObject(LotteryManager.shared)
                    } label: {
                        ContentListView(systemImageName: "gamecontroller.fill", text: "转盘")
                    }
                } header: {
                    Text("帮你做决定?")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                
                Section {
                    NavigationLink {
                        BaziLunarView()
                    } label: {
                        ContentListView(systemImageName: "calendar", text: "生辰八字")
                    }
                } header: {
                    Text("万年历")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                Section {
                    
                    NavigationLink {
                        QRCodeView()
                    } label: {
                        ContentListView(systemImageName: "qrcode", text: "生成二维码")
                    }
                    
                    NavigationLink {
                        BarCodeView()
                    } label: {
                        ContentListView(systemImageName: "barcode", text: "生成条形码")
                    }
                    
                    
                } header: {
                    Text("二维码/条形码")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                Section {
                    NavigationLink {
                        LinkInutView(type: .screenshot)
                    } label: {
                        ContentListView(systemImageName: "doc.text.image", text: "网页截长图")
                    }
                    
                    NavigationLink {
                        LinkInutView(type: .extractImages)
                    } label: {
                        ContentListView(systemImageName: "photo.on.rectangle.angled", text: "提取网页图片")
                    }
                } header: {
                    Text("网页工具")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                
                Section {
                    NavigationLink {
                        Video2GIFView()
                    } label: {
                        ContentListView(systemImageName: "video.square", text: "视频转GIF")
                    }
                                     
                } header: {
                    Text("其他")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                
                Section {
                    NavigationLink {
                        BrowerView(urlString: Common.aboutUsURL, type: .normal)
                    } label: {
                        ContentListView(systemImageName: "info.circle", text: "关于我们")
                    }
                    
                    NavigationLink {
                        LocalWebView(htmlPath: Bundle.main.path(forResource: "eula", ofType: "html")!, title: "EULA")
                    } label: {
                        ContentListView(systemImageName: "doc.text", text: "EULA")
                    }
                    
                    NavigationLink {
                        LocalWebView(htmlPath: Bundle.main.path(forResource: "user", ofType: "html")!, title: "用户协议")
                    } label: {
                        ContentListView(systemImageName: "shield.lefthalf.filled", text: "用户协议")
                    }
                    
                    NavigationLink {
                        LocalWebView(htmlPath: Bundle.main.path(forResource: "privacy", ofType: "html")!, title: "隐私政策")
                    } label: {
                        ContentListView(systemImageName: "checkmark.shield", text: "隐私政策")
                    }
                    
                } header: {
                    Text("关于")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
            }
            .navigationTitle("主页")
        }
    }
}

#Preview {
    ContentView()
}
