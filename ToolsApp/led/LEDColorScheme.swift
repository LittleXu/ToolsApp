//
//  LEDColorScheme.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/22.
//

import Foundation
import SwiftUI
struct LEDColorScheme: Identifiable {
    let id = UUID()
    let name: String
    let textColor: Color
    let backgroundColor: Color
}

let colorSchemes: [LEDColorScheme] = [
    // 复古绿幕风
    .init(name: "经典绿幕", textColor: .green, backgroundColor: .black),
    
    // 暗夜红焰
    .init(name: "炽热红黑", textColor: .red,
          backgroundColor: Color(.sRGB, red: 28/255, green: 28/255, blue: 30/255, opacity: 1)),
    
    // 温柔少女粉
    .init(name: "温柔粉紫", textColor: Color(.sRGB, red: 1.0, green: 143/255, blue: 163/255, opacity: 1),
          backgroundColor: Color(.sRGB, red: 26/255, green: 11/255, blue: 46/255, opacity: 1)),

    // 冰蓝夜行
    .init(name: "冰蓝黑夜", textColor: Color(.sRGB, red: 10/255, green: 190/255, blue: 1.0, opacity: 1),
          backgroundColor: .black),

    // 皇家金蓝
    .init(name: "高贵金蓝", textColor: Color(.sRGB, red: 1.0, green: 215/255, blue: 0, opacity: 1),
          backgroundColor: Color(.sRGB, red: 0, green: 31/255, blue: 63/255, opacity: 1)),

    // 柠檬夏日
    .init(name: "柠檬夏日", textColor: Color(.sRGB, red: 0.95, green: 0.95, blue: 0.1, opacity: 1),
          backgroundColor: Color(.sRGB, red: 0.1, green: 0.1, blue: 0.6, opacity: 1)),

    // 深空紫电
    .init(name: "深空紫电", textColor: Color(.sRGB, red: 180/255, green: 82/255, blue: 255/255, opacity: 1),
          backgroundColor: Color(.sRGB, red: 20/255, green: 0/255, blue: 40/255, opacity: 1)),

    // 薄荷奶绿
    .init(name: "薄荷奶绿", textColor: Color(.sRGB, red: 0.4, green: 0.9, blue: 0.8, opacity: 1),
          backgroundColor: Color(.sRGB, red: 0.05, green: 0.2, blue: 0.15, opacity: 1)),

    // 暖光咖橙
    .init(name: "暖光咖橙", textColor: Color(.sRGB, red: 1.0, green: 165/255, blue: 0.4, opacity: 1),
          backgroundColor: Color(.sRGB, red: 0.2, green: 0.1, blue: 0.0, opacity: 1)),

    // 青春水蓝
    .init(name: "青春水蓝", textColor: Color(.sRGB, red: 0.2, green: 0.9, blue: 1.0, opacity: 1),
          backgroundColor: Color(.sRGB, red: 0.0, green: 0.2, blue: 0.3, opacity: 1))
]
