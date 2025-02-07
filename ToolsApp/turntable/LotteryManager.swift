//
//  LotteryManager.swift
//  ToolsApp
//
//  Created by liuxu on 2024/6/4.
//

import Foundation

struct LotterySection: Codable, Equatable {
    static func == (lhs: LotterySection, rhs: LotterySection) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    let sectionTitle: String
    var lotteies: [Lottery]
    let type: String
}


extension LotterySection {
    static func key() -> String {
        return "ToolsApp_LotterySection_Key"
    }
    
    static func defaultSection() -> LotterySection {
        return LotterySection(sectionTitle: "系统", lotteies: [
            .dinner(),
            .holidays(),
            .weekends()
        ], type: "SYSTEM")
    }
    
    static func customSection() -> LotterySection {
        return LotterySection(sectionTitle: "自定义", lotteies: [
            .custom()
        ], type: "CUSTOM")
    }
}

class LotteryManager: ObservableObject {
    
    static let shared = LotteryManager()
    
    @Published var sections: [LotterySection] = []
    
    init() {
        sections = createSections()
    }
    
    func createSections() -> [LotterySection] {
        if let savedData = UserDefaults.standard.data(forKey: LotterySection.key()) {
            let decoder = JSONDecoder()
            if let sections = try? decoder.decode([LotterySection].self, from: savedData) {
                return sections
            }
        }
        return [
            LotterySection.defaultSection(),
            LotterySection.customSection()
        ]
    }
    
    func save(sections: [LotterySection]) {
        self.sections = sections
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(sections) {
            UserDefaults.standard.setValue(encoded, forKey: LotterySection.key())
            UserDefaults.standard.synchronize()
        }
       
    }
}

struct Lottery: Codable {
    var id = UUID()
    var title: String
    var imageName: String
    var items: [LotteryItem]
    let type: String
}

extension Lottery {
    
    static func dinner() -> Lottery {
        return Lottery(title: "晚上去吃啥?", imageName: "fork.knife", items: foods.map { LotteryItem(name: $0) }, type: "SYSTEM")
    }
    
    static func weekends() -> Lottery {
        return Lottery(title: "周末去干啥?", imageName: "figure.fishing", items: activities.map { LotteryItem(name: $0) }, type: "SYSTEM")
    }
    
    static func holidays() -> Lottery {
        return Lottery(title: "假期去哪玩?", imageName: "figure.gymnastics", items: cities.map { LotteryItem(name: $0) }, type: "SYSTEM")
    }
    
    static func custom() -> Lottery {
        return Lottery(title: "新建自定义", imageName: "figure.child", items: [], type: "ADD")
    }
    
}


var foods: [String] = [
    "火锅",
    "烧烤",
    "炒菜",
    "西餐",
    "自助",
]

var activities: [String] = [
    "钓鱼",
    "徒步",
    "爬山",
    "游泳",
    "打球",
    "睡觉"
]

var cities: [String] = [
    "北京",
    "上海",
    "广州",
    "深圳",
    "杭州",
    "成都",
    "西安",
    "洛阳"
]
