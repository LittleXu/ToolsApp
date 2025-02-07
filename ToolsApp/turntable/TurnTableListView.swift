//
//  TurnTableListView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/30.
//

import Foundation
import SwiftUI


struct TurnTableListView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var manager: LotteryManager
    
    var body: some View {
        List {
            ForEach(manager.sections, id: \.id) { section in
                Section {
                    ForEach(section.lotteies, id: \.id) { lottery in
                        NavigationLink {
                            if lottery.type == "ADD" {
                                NewTurnTableView(sections: $manager.sections)
                            } else {
                                TurnTableView(lottery: lottery, sections: $manager.sections)
                            }
                        } label: {
                            ContentListView(systemImageName: lottery.imageName, text: lottery.title)
                        }
                    }
                } header: {
                    Text(section.sectionTitle)
                        .padding(EdgeInsets(top: 0, leading: -15, bottom: 8, trailing: 0))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("转盘列表")
            }
            .foregroundColor(.black)
        }))
    }
        
}

#Preview {
    NavigationView(content: {
        TurnTableListView()
            .environmentObject(LotteryManager.shared)
    })
}

