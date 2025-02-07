//
//  NetworkScannerView.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/22.
//

import SwiftUI

struct NetworkScannerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var devices: [String] = []
    
    var body: some View {
        List {
            
            Section {
                ForEach(devices, id: \.self) { item in
                    Text(item)
                }
            } header: {
                Text("设备列表").padding(EdgeInsets(top: 0, leading: -16, bottom: 8, trailing: 0))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("同一网络下的设备")
            }
            .foregroundColor(.black)
        }))
        
    }
}

#Preview {
    NavigationView(content: {
        NetworkScannerView()
    })
}
