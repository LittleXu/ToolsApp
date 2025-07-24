//
//  LEDBannerFullScreenView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/22.
//

import SwiftUI

struct LEDBannerFullScreenView: View {
    var text: String
    var fontSize: CGFloat
    var scrollSpeed: Double
    var textColor: Color
    var backgroundColor: Color

    @Environment(\.dismiss) var dismiss
    @State private var showCloseButton = true
    @State private var hideStatusBar = true
    
    @State private var viewSize: CGSize = .zero
    @State private var reloadKey: UUID = UUID()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollingTextView(
                    text: text,
                    fontSize: fontSize,
                    speed: scrollSpeed,
                    color: textColor
                )
                .id(reloadKey) // 强制在尺寸变化时刷新视图
                .frame(height: fontSize * 1.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                // 关闭按钮
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            hideStatusBar = false
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .opacity(showCloseButton ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showCloseButton)
                    }
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showCloseButton = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCloseButton = false
                }
            }
            .onAppear {
                hideStatusBar = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showCloseButton = false
                }
            }
            .onChange(of: geometry.size) { newSize in
                if newSize != viewSize {
                    viewSize = newSize
                    reloadKey = UUID()  // 改变 key 强制重新加载
                }
            }
        }
        
        .statusBarHidden(hideStatusBar)
    }
}

#Preview {
    LEDBannerFullScreenView(text: "我爱你中国,亲爱的母亲", fontSize: 40, scrollSpeed: 300, textColor: .red, backgroundColor: .black)
}
