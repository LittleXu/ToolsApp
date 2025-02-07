//
//  LotteryWheelView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/28.
//

import SwiftUI

struct LotteryItem: Codable {
    var id = UUID()
    let name: String
}

struct RotationEffectModifier: ViewModifier {
    @Binding var rotationAngle: Double
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(rotationAngle))
            .animation(rotationAngle > 0 ? .easeInOut(duration: 5.0) : .none, value: rotationAngle)
    }
}


struct LotteryWheelView: View {
    
    let colors: [Color] = [
        Color(hex: "#FF5733"),
        Color(hex: "#FF8D1A"),
        Color(hex: "#FFC300"),
        Color(hex: "#28B463"),
        Color(hex: "#1ABC9C"),
        Color(hex: "#3498DB"),
        Color(hex: "#9B59B6"),
        Color(hex: "#FF69B4"),
        Color(hex: "#B3B300"),
        Color(hex: "#40E0D0")
    ]
    
    @Binding var items: [LotteryItem]
    @Binding var rotationAngle: Double
    @State var showAnimation = false
    var body: some View {
        ZStack {
            ForEach(items, id: \.id) { item in
                let index = items.firstIndex(where: { $0.id == item.id })!
                let angle = 360.0 / Double(items.count)
                let start = angle * Double(index) - 90
                let end = start + angle
                SectorShapeView(startAngle: .degrees(start), endAngle: .degrees(end), text: item.name, color: color(index))
            }
        }
        .modifier(RotationEffectModifier(rotationAngle: $rotationAngle))
        .frame(width: 300, height: 300)
        .background(Color.yellow)
        .clipShape(Circle())
    }
    
    func color(_ index: Int) -> Color {
        return colors[index % colors.count]
    }
    
    func degrees(itemIndex: Int, count: Int) -> Double {
        return Double(itemIndex) * 360.0 / Double(items.count)
    }
}


#Preview {
    LotteryWheelView(items: .constant([
        LotteryItem(name: "Alice"),
        LotteryItem(name: "Bob"),
        LotteryItem(name: "Cindy"),
        LotteryItem(name: "Dany"),
        LotteryItem(name: "Emmily"),
    ]), rotationAngle: .constant(0))
}
