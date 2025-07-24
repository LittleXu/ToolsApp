//
//  LEDBannerConfig.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/22.
//

import Foundation
import SwiftUI
import UIKit

struct LEDBannerConfig: Identifiable {
    var id = UUID()
    let text: String
    let textColor: Color
    let backgroundColor: Color
    let fontSize: CGFloat
    let speed: CGFloat
    
    init(id: UUID = UUID(), text: String, textColor: Color, backgroundColor: Color, fontSize: CGFloat, speed: CGFloat) {
        self.id = id
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.speed = speed
    }
}

extension LEDBannerConfig {
    
    private static let storageKey = "LEDBannerConfigHistory"
    
    // 将单个配置编码成字典形式（方便序列化）
    private func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "text": text,
            "textColor": UIColor(textColor).toHexString(),
            "backgroundColor": UIColor(backgroundColor).toHexString(),
            "fontSize": fontSize,
            "speed": speed
        ]
    }
    
    // 从字典恢复一个配置实例
    private static func fromDictionary(_ dict: [String: Any]) -> LEDBannerConfig? {
        guard
            let idString = dict["id"] as? String,
            let id = UUID(uuidString: idString),
            let text = dict["text"] as? String,
            let textColorHex = dict["textColor"] as? String,
            let backgroundColorHex = dict["backgroundColor"] as? String,
            let fontSize = dict["fontSize"] as? CGFloat,
            let speed = dict["speed"] as? CGFloat
        else {
            return nil
        }
        
        return LEDBannerConfig(
            id: id,
            text: text,
            textColor: Color(UIColor(hex: textColorHex)),
            backgroundColor: Color(UIColor(hex: backgroundColorHex)),
            fontSize: fontSize,
            speed: speed
        )
    }
    
    // 保存当前配置到本地历史列表
    func saveToHistory() {
        var history = LEDBannerConfig.loadHistory()
        // 过滤已有的同id配置（避免重复）
        history.removeAll(where: { $0.id == self.id })
        history.insert(self, at: 0)
        let dictArray = history.map { $0.toDictionary() }
        UserDefaults.standard.set(dictArray, forKey: LEDBannerConfig.storageKey)
    }
    
    // 读取本地所有配置历史
    static func loadHistory() -> [LEDBannerConfig] {
        guard
            let dictArray = UserDefaults.standard.array(forKey: storageKey) as? [[String: Any]]
        else {
            return []
        }
        
        return dictArray.compactMap { fromDictionary($0) }
    }
    
    /// 替换本地缓存为新的配置数组
    static func replaceHistory(with newConfigs: [LEDBannerConfig]) {
        let dictArray = newConfigs.map { $0.toDictionary() }
        UserDefaults.standard.set(dictArray, forKey: LEDBannerConfig.storageKey)
    }
}


// MARK: - UIColor 扩展，用来转换 Color <-> Hex

extension UIColor {
    // 初始化UIColor，支持hex字符串，如 "#FF0000" 或 "FF0000"
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        if hexString.count == 6 {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                blue: CGFloat(rgbValue & 0x0000FF) / 255,
                alpha: 1.0
            )
        } else {
            // 默认黑色
            self.init(white: 0, alpha: 1)
        }
    }
    
    // 转成 hex 字符串
    func toHexString() -> String {
        var r: CGFloat=0, g: CGFloat=0, b: CGFloat=0, a: CGFloat=0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06X", rgb)
    }
}

