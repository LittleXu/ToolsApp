//
//  ColorExtension.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/29.
//

import Foundation
import SwiftUI

extension Color {
    static func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    init(hex: String) {
           let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int: UInt64 = 0
           Scanner(string: hex).scanHexInt64(&int)
           let r, g, b: UInt64
           switch hex.count {
           case 3: // RGB (12-bit)
               (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
           default:
               (r, g, b) = (1, 1, 0) // 默认颜色 (黄色) 以防输入无效
           }
           self.init(
               .sRGB,
               red: Double(r) / 255,
               green: Double(g) / 255,
               blue: Double(b) / 255,
               opacity: 1
           )
       }
}
