//
//  EditTurnTableView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/31.
//

import Foundation
import SwiftUI

struct EditTurnTableView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var sections: [LotterySection]
    @Binding var lottery: Lottery
    
    @State var newItem = ""
    
    let systemImageNames: [String] = [
        "star.fill",
        "fork.knife",
        "cup.and.saucer",
        "figure.walk",
        "figure.run",
        "figure.basketball",
        "figure.dance",
        "figure.fishing",
        "figure.gymnastics",
        "figure.socialdance",
        "sun.max.fill",
        "cloud.fill",
        "cloud.drizzle.fill",
        "cloud.snow.fill",
        "cloud.bolt.fill"
    ]
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("请输入标题", text: $lottery.title)
                }
                .frame(height: 44)
                
                VStack (alignment: .leading) {
                    Text("请选择图标")
                        .frame(height: 44)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(systemImageNames, id: \.self) { imageName in
                                Image(systemName: imageName)
                                    .foregroundColor(imageName == lottery.imageName ? .blue : .gray)
                                    .onTapGesture {
                                        withAnimation {
                                            lottery.imageName = imageName
                                        }
                                    }
                            }
                        }
                    }
                }
            } header: {
                Text("标题和图标")
                    .padding(EdgeInsets(top: 0, leading: -15, bottom: 8, trailing: 0))
            }
            
            Section {
                ForEach(lottery.items, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                lottery.items.removeAll { $0.name == item.name }
                            }
                        }, label: {
                            Image(systemName: "delete.left.fill")
                                .foregroundColor(.red)
                        })
                    }
                    .frame(height: 44)
                }
                
                HStack {
                    TextField("请输入选项", text: $newItem)
                    Button {
                        if !newItem.isEmpty && !lottery.items.contains(where: { $0.name == newItem }) {
                            withAnimation {
                                lottery.items.append(LotteryItem(name: newItem))
                            }
                            newItem = ""
                        }
                    } label: {
                        Text("新增")
                            .foregroundStyle(.blue)
                    }
                }
                .frame(height: 44)
            } header: {
                Text("选项")
                    .padding(EdgeInsets(top: 0, leading: -15, bottom: 8, trailing: 0))
            }
            
            Section {
                Button(action: {
                    saveAction()
                }, label: {
                    Text("保存")
                        .foregroundColor(.blue)
                }).frame(height: 44)
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("新建自定义")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
    }
    
    func saveAction() {
        guard !lottery.title.isEmpty else {
            showError = true
            errorMessage = "请输入标题!"
            return
        }
        
        guard lottery.items.count >= 2 else {
            showError = true
            errorMessage = "请输入至少两个选项!"
            return
        }
        
        
        for (index, section) in sections.enumerated() {
            for (row, lot) in section.lotteies.enumerated() {
                if lot.id == lottery.id {
                    var section = section
                    section.lotteies[row] = lottery
                    sections[index] = section
                    LotteryManager.shared.save(sections: sections)
                }
            }
        }
        showError = true
        errorMessage = "已保存!"
    }
}

#Preview {
    NavigationView(content: {
        EditTurnTableView(sections: .constant(LotteryManager.shared.sections), lottery: .constant(Lottery.dinner()))
    })
    
}

