//
//  LinkInutView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/22.
//

import SwiftUI


enum BrowerType {
    case screenshot
    case extractImages
    
    func title() -> String {
        switch self {
        case .screenshot:
            return "网页截长图"
        case .extractImages:
            return "提取网页图片"
        }
    }
    
    
    func buttonTitle() -> String {
        switch self {
        case .screenshot:
            return "截图"
        case .extractImages:
            return "提取"
        }
    }
    
    func buttonImageName() -> String {
        switch self {
        case .screenshot:
            return "camera.viewfinder"
        case .extractImages:
            return "photo.on.rectangle.angled"
        }
    }
}

struct LinkInutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let type: BrowerType
    
    @State var link: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var pushNext = false
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("请输入网址", text: $link)
                        .frame(height: 44)
                }
                .frame(height: 44)
            }
            
            Section {
                VStack {
                    Button {
                        UIApplication.shared.endEditing(true)
                        guard !link.isEmpty else {
                            self.errorMessage = "请输入网址"
                            self.showError = true
                            return
                        }
                        self.pushNext = true
                    } label: {
                        NavigationLink(
                            destination: BrowerView(urlString: link.trimmingCharacters(in: .whitespacesAndNewlines), type: type),
                            isActive: $pushNext,
                            label: {
                                Text("访问")
                            })
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
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
                Text(type.title())
            }
            .foregroundColor(.black)
        }))
        .alert(isPresented: $showError) {
            Alert(title: Text("提示"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
    }
}


#Preview {
    NavigationView(content: {
        LinkInutView(type: .extractImages)
    })
}
