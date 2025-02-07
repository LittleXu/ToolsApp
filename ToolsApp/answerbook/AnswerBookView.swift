//
//  AnswerBookView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/6/4.
//

import Foundation
import SwiftUI
import PopupView


struct AnswerBookView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        List {
            Section {
                Button {
                    errorMessage = randomAnswer()
                    showError = true
                } label: {
                    Text("点击获取答案")
                        .foregroundColor(.blue)
                }
                .frame(height: 44)
            } header: {
                Text("当你遇事不决时，答案之书将会给你指引\n心中默念一个问题, 点击按钮获取答案。")
                    .padding(EdgeInsets(top: 0, leading: -15, bottom: 15, trailing: 0))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("答案之书")
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text(""), message: Text(errorMessage), dismissButton: .default(Text("好的")))
        }
    }
    
    func randomAnswer() -> String {
        return answers.randomElement() ?? ""
    }
}

#Preview {
    NavigationView(content: {
        AnswerBookView()
    })
}
