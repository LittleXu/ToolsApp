//
//  HoleShape.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/15.
//

import Foundation
import UIKit
import SwiftUI

struct CameraOverlayShape: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        // 整个遮罩
        path.addRect(rect)

        // 中间挖掉的圆洞
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))

        return path
    }
}
