//
//  BaziLunarView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/5/15.
//

import SwiftUI
import LunarSwift

/// 获取生辰八字
func getBazi(from date: Date) -> [String: String] {
    let lunar = Lunar.fromDate(date: date)
    return [
        "年柱": lunar.yearInGanZhi,
        "月柱": lunar.monthInGanZhi,
        "日柱": lunar.dayInGanZhi,
        "时柱": lunar.timeInGanZhi
    ]
}

struct BaziLunarView: View {
    @State private var selectedDate = Date()
    @State private var result: [String: String] = [:]
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    DatePicker("选择出生时间", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                } header: {
                    Text("请选择出生时间")
                        .padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
                }
                
                Section {
                    Button {
                        result = getBazi(from: selectedDate)
                        errorMessage = getGanzhiString()
                        showError = true
                    } label: {
                        Text("计算八字")
                            .foregroundColor(.blue)
                    }
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
                Text("生辰八字")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("您的生辰八字为:"), message: Text(errorMessage), dismissButton: .default(Text("好的")))
        }
    }
    
    
    private func getGanzhiString() -> String {
        return "年柱: \(result["年柱"]!)\n" +
        "月柱: \(result["月柱"]!)\n" +
        "日柱: \(result["日柱"]!)\n" +
        "时柱: \(result["时柱"]!)"
    }
}

#Preview {
    NavigationView {
        BaziLunarView()
    }
}
