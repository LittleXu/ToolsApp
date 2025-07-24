//
//  ScrollingTextView.swift
//  ToolsApp
//
//  Created by liuxu on 2025/7/17.
//

import SwiftUI

struct ScrollingTextView: View {

    let text: String
    let fontSize: CGFloat
    let speed: Double
    let color: Color

    @State private var offsetX: CGFloat = 0
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            Text(text)
                .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .lineLimit(1)
                .fixedSize()
                .fixedSize()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                textWidth = proxy.size.width
                                offsetX = geo.size.width
                            }
                    }
                )
                .offset(x: offsetX)
                .onAppear {
                    startScrolling(fullWidth: geo.size.width)
                }
        }
    }

    func startScrolling(fullWidth: CGFloat) {
        let totalDistance = fullWidth + textWidth
        let duration = totalDistance / CGFloat(speed)

        withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
            offsetX = -textWidth
        }
    }
}

#Preview {
    ScrollingTextView(text: "❤️❤️❤️❤️❤️❤️", fontSize: 15, speed: 100, color: .red)
}
