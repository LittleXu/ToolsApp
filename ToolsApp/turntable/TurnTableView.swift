//
//  TurnTableView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/28.
//

import SwiftUI

struct TurnTableView: View {
    @State var lottery: Lottery
    @Binding var sections: [LotterySection]
    @State private var selectedName: String?
    @State private var rotationAngle: Double = 0.0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Button("点击开始") {
                spinWheel()
            }
            .padding()
            
            Image(systemName: "arrow.down")
                .foregroundColor(.red)
            
            LotteryWheelView(items: $lottery.items, rotationAngle: $rotationAngle)
            
            LimitHeightGifView(path: randomGoGoGoURL())
                .frame(height: 80)
                .padding()
            
            Text(lottery.title).padding()
            Text(selectedName ?? "点击开始按钮开始选择")
                .foregroundColor(selectedName != nil ? .red : .gray)
                .font(selectedName != nil ? .caption : .caption2)
        }
        .navigationBarBackButtonHidden(true) // 隐藏默认返回按钮
        .navigationBarItems(leading: Button(action: {
            // 自定义返回按钮的动作
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text(lottery.title)
            }
            .foregroundColor(.black)
        }, trailing: HStack {
            /// 编辑
            NavigationLink {
                EditTurnTableView(sections: $sections, lottery: $lottery)
            } label: {
                Image(systemName: "square.and.pencil")
            }

          
            
            /// 删除
            if lottery.type == "CUSTOM" {
                Button  {
                    for (index, section) in sections.enumerated() {
                        for (row, lot) in section.lotteies.enumerated() {
                            if lot.id == lottery.id {
                                var section = section
                                section.lotteies.remove(at: row)
                                sections[index] = section
                                LotteryManager.shared.save(sections: sections)
                            }
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Image(systemName: "delete.left")
                }
            }

        }.foregroundColor(.black))
        
    }
    
    
    func randomGoGoGoURL() -> String {
        let random = Int.random(in: 1...4)
        return Bundle.main.path(forResource: "gogogo_\(random)", ofType: "gif")!
    }
    
    func spinWheel() {
        guard lottery.items.count > 0 else { return }
        let angle: Double = 3600
        let randomAngle = Double.random(in: 0..<360)
        rotationAngle += (angle + randomAngle)
        let index = Int((rotationAngle.truncatingRemainder(dividingBy: 360)) / Double(360 / lottery.items.count))
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            selectedName = lottery.items[lottery.items.count - 1 - index].name
        }
    }
}

#Preview {
    NavigationView(content: {
        TurnTableView(lottery: Lottery.dinner(), sections: .constant(LotteryManager.shared.sections))
    })
}
