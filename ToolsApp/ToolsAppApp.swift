//
//  ToolsAppApp.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/17.
//

import SwiftUI

@main
struct ToolsAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    _ = DeviceDiscovery()
                })
        }
    }
}
