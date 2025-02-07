//
//  ApplicationExtension.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/27.
//

import Foundation
import UIKit
// MARK: extension for UIApplication

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.endEditing(force) }
    }
}
