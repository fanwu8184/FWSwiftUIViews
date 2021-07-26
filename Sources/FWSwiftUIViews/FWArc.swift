//
//  File.swift
//  
//
//  Created by Fan Wu on 7/27/21.
//

import SwiftUI

@available(macOS 10.15, *)
internal struct FWArc: InsettableShape {
    private let endDegrees: Double
    private var insetAmount: CGFloat = 0
    
    init(_ endDegrees: Double = 360) {
        self.endDegrees = endDegrees
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2 - insetAmount,
            startAngle: .degrees(0),
            endAngle: .degrees(endDegrees),
            clockwise: false)
        return path
    }
}
