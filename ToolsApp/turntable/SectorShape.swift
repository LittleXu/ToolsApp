//
//  SectorShape.swift
//  ToolsApp
//
//  Created by liuxu on 2024/5/29.
//

import SwiftUI

struct SectorShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        path.move(to: center)
        path.addArc(center: center, radius: rect.size.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}


struct SectorShapeView: View {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                SectorShape(startAngle: startAngle, endAngle: endAngle)
                    .fill(color)
                Text(text)
                    .foregroundColor(.white)
                    .offset(CGSize(width: geometry.size.width / 4, height: 0))
                    .rotationEffect(.degrees(startAngle.degrees + (endAngle.degrees - startAngle.degrees) / 2))
            }
        }
       
    }
}

#Preview {
    SectorShapeView(startAngle: .degrees(0), endAngle: .degrees(120), text: "Sector", color: Color.randomColor())
        .frame(width: 200, height: 200)
}
