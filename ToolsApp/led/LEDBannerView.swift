//
//  LEDBannerView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/17.
//

import SwiftUI

struct LEDBannerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    
//    let colors: [Color] = [.red, .green, .blue, .yellow, .white, .purple]
    
    @State private var text = "XXX ❤️❤️❤️❤️"
    @State private var fontSize: CGFloat = 40
    @State private var scrollSpeed: Double = 100  // 单位：点/秒
    @State private var textColor: Color = .green
    @State private var backgroundColor: Color = .black
    
    @State private var offsetX: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    
    @State private var isFullScreenBanner = false
    
    @State private var showColorSchemePicker = false
    @State private var showCustomColorPicker = false
    
    @State private var customColorSchemes: [LEDColorScheme] = []
    @State private var reloadKey = UUID()
    
    var body: some View {
        
        List {
            
            Section(header:
                        Text("预览").padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            ) {
                ZStack {
                    backgroundColor.cornerRadius(10)
                    
                    GeometryReader { geo in
                        ScrollingTextView(text: text, fontSize: fontSize, speed: scrollSpeed, color: textColor)
                            .clipped()
                            .frame(width: geo.size.width, height: fontSize * 1.2) // 保证高度合适
                            .position(x: geo.size.width / 2, y: geo.size.height / 2) // ✅ 垂直 + 水平居中
                            .id(reloadKey)
                    }
                }
                .aspectRatio(16/9, contentMode: .fit)
            }
            
            
            Section(header: Text("输入文字").padding(EdgeInsets(top: 0, leading: -8, bottom: 8, trailing: 0))) {
                TextField("请输入应援文字", text: $text)
                    .frame(height: 44)
            }
            
            Section(header: Text("字体大小").padding(EdgeInsets(top: 0, leading: -8, bottom: 8, trailing: 0))) {
                HStack {
                    Text("字体大小")
                    Slider(value: $fontSize, in: 20...100)
                    Text("\(Int(fontSize))")
                        .frame(width: 40, alignment: .trailing)
                }
                .frame(height: 44)
            }
            
            Section(header: Text("滚动速度").padding(EdgeInsets(top: 0, leading: -8, bottom: 8, trailing: 0))) {
                HStack {
                    Text("滚动速度")
                    Slider(value: $scrollSpeed, in: 30...300)
                    Text(String(format: "%.0f", scrollSpeed))
                        .frame(width: 40, alignment: .trailing)
                }
                .frame(height: 44)
            }
            
            Section(header:
                        Text("当前风格")
                .padding(EdgeInsets(top: 0, leading: -8, bottom: 8, trailing: 0))
            ) {
                
                Button(action: {
                    showColorSchemePicker = true
                }) {
                    HStack(spacing: 16) {
                        Text("当前风格")
                        ZStack {
                            Circle()
                                .fill(backgroundColor)
                                .frame(width: 30, height: 30)
                                .offset(x: 10)
                            Circle()
                                .fill(textColor)
                                .frame(width: 30, height: 30)
                                .offset(x: -10)
                        }
                        .frame(width: 60, height: 40)
                    }
                    .frame(height: 44)
                }
                
                
            }
            
            Section(header: Text("需关闭屏幕方向锁定,然后将手机调整成横向").padding(EdgeInsets(top: 0, leading: -8, bottom: 8, trailing: 0))) {
                Button(action: {
                    isFullScreenBanner = true
                    let config = LEDBannerConfig(text: text, textColor: textColor, backgroundColor: backgroundColor, fontSize: fontSize, speed: scrollSpeed)
                    // 保存config
                    config.saveToHistory()
                }) {
                    Text("应用")
                        .foregroundColor(.blue)
                        .frame(height: 44)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("应援字幕机")
            }
            .foregroundColor(.black)
        }), trailing: NavigationLink(destination: {
            LEDBannerHistoryView()
        }, label: {
            Image(systemName: "timer")
                    .foregroundColor(.primary)
        }))
        .sheet(isPresented: $showColorSchemePicker) {
            NavigationView {
                List {
                    ForEach(colorSchemes + customColorSchemes) { scheme in
                        Button(action: {
                            textColor = scheme.textColor
                            backgroundColor = scheme.backgroundColor
                            showColorSchemePicker = false
                        }) {
                            HStack(spacing: 16) {
                                Text(scheme.name)
                                    .foregroundColor(.primary)
                                ZStack {
                                    Circle().fill(scheme.textColor).frame(width: 30, height: 30)
                                        .offset(x: 10)
                                    
                                    Circle().fill(scheme.backgroundColor).frame(width: 30, height: 30)
                                        .offset(x: -10)
                                    
                                }
                                .frame(width: 60, height: 40)
                                
                            }
                            .frame(height:44)
                        }
                    }
                    
                    Button(action: {
                        showColorSchemePicker = false
                        showCustomColorPicker = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("自定义配色方案")
                        }
                        .frame(height: 44)
                    }
                }
                .navigationTitle("选择风格")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") {
                            showColorSchemePicker = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCustomColorPicker) {
            NavigationView {
                Form {
                    Section(header: Text("文字颜色")) {
                        ColorPicker("选择文字颜色", selection: $textColor)
                    }
                    Section(header: Text("背景颜色")) {
                        ColorPicker("选择背景颜色", selection: $backgroundColor)
                    }
                }
                .navigationTitle("自定义配色")
                .navigationBarItems(
                    leading: Button("取消") {
                        showCustomColorPicker = false
                    },
                    trailing: Button("保存") {
                        let newScheme = LEDColorScheme(
                            name: "自定义",
                            textColor: textColor,
                            backgroundColor: backgroundColor
                        )
                        customColorSchemes.append(newScheme)
                        showCustomColorPicker = false
                        showColorSchemePicker = false
                    }
                )
            }
        }
        
        .fullScreenCover(isPresented: $isFullScreenBanner) {
                LEDBannerFullScreenView(
                    text: text,
                    fontSize: fontSize * 16 / 9.0,
                    scrollSpeed: scrollSpeed,
                    textColor: textColor,
                    backgroundColor: backgroundColor
                )
        }
        .onChange(of: scrollSpeed, { oldValue, newValue in
            print("scrollSpeed changed from \(oldValue) to \(newValue)")
            reloadKey = UUID()
        })
        .onChange(of: text, { oldValue, newValue in
            print("text changed from \(oldValue) to \(newValue)")
            reloadKey = UUID()
        })
        .onChange(of: fontSize, { oldValue, newValue in
            print("fontSize changed from \(oldValue) to \(newValue)")
            reloadKey = UUID()
        })
        
        .onAppear {
            print("On Appear")
            reloadKey = UUID()
        }
    }
}

#Preview {
    NavigationView {
        LEDBannerView()
    }
}
