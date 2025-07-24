//
//  LEDBannerHistoryView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/22.
//

import SwiftUI

struct LEDBannerHistoryRow: View {
    let config: LEDBannerConfig
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment:.leading) {

            HStack {
                ZStack {
                    Circle()
                        .fill(config.backgroundColor)
                        .frame(width: 30, height: 30)
                        .offset(x: 10)
                    Circle()
                        .fill(config.textColor)
                        .frame(width: 30, height: 30)
                        .offset(x: -10)
                }
                .frame(width: 60, height: 40)
                
                Text(config.text)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Spacer()
                Button(action: onSelect) {
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
//                Button(action: onEdit) {
//                    Image(systemName: "pencil.line")
//                        .foregroundColor(.primary)
//                        .padding(8)
//                        .background(Color(.systemGray6))
//                        .clipShape(Circle())
//                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
        }
    }
}


struct LEDBannerHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var history: [LEDBannerConfig] = []
    @State private var currentConfig: LEDBannerConfig?
    
    var body: some View {
        VStack {
            if history.isEmpty {
                Text("暂无数据")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(history, id: \.id) { config in
                        LEDBannerHistoryRow(
                            config: config,
                            onSelect: { currentConfig = config },
                            onEdit: { print("编辑 \(config.text)") },
                            onDelete: {
                                if let index = history.firstIndex(where: { $0.id == config.id }) {
                                    history.remove(at: index)
                                }
                            }
                        )
                        .buttonStyle(.plain)  // ✅ 添加这一行
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("历史记录")
                }
                .foregroundColor(.black)
            })
        .fullScreenCover(item: $currentConfig) { config in
            LEDBannerFullScreenView(
                text: config.text,
                fontSize: config.fontSize * 16 / 9.0,
                scrollSpeed: config.speed,
                textColor: config.textColor,
                backgroundColor: config.backgroundColor
            )
        }
        .onAppear {
            history = LEDBannerConfig.loadHistory()
        }
        .onDisappear {
            LEDBannerConfig.replaceHistory(with: history)
        }
    }
}


struct FallbackBannerView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                Text("未选择配置")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            // 右上角的叉号按钮
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
                    .padding(12)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding(.top, 40) // 顶部内边距适配刘海屏
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    NavigationView {
        LEDBannerHistoryView(history: [
            LEDBannerConfig(id: UUID(), text: "欢迎", textColor: .red, backgroundColor: .black, fontSize: 20, speed: 50),
            LEDBannerConfig(id: UUID(), text: "历史记录", textColor: .green, backgroundColor: .gray, fontSize: 18, speed: 100)
        ])
    }
    
}
