//
//  SwiftUIView.swift
//  
//
//  Created by Fan Wu on 7/27/21.
//

import SwiftUI

@available(macOS 10.15, *)
public struct FWArcSliderView: View {
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double
    private let outerDiameter: CGFloat
    private let lineWidth: CGFloat
    private let endDegrees: Double
    private let trackColor: Color
    private let progressColor: Color
    private let dragCircleColor: Color
    private let isDashed: Bool
    private let onValueChangeEnded: (() -> ())?
    private var progressValue: Double { value - range.lowerBound }
    private var rangeValue: Double {range.upperBound - range.lowerBound }
    private var progress: Double { progressValue / rangeValue }
    private var midDiameter: CGFloat { outerDiameter - lineWidth }
    private var dragCircleDegrees: Double { getDragCircleDegrees() }
    private let dashFactor = 0.9
    private var segmentDegrees: Double { step > 0 ? endDegrees * step / rangeValue : endDegrees }
    private var segmentLength: Double { (segmentDegrees * .pi * Double(midDiameter / 2)) / 180 }
    private var dashLength: CGFloat { CGFloat(segmentLength * dashFactor) }
    private var gapLength: CGFloat { CGFloat(segmentLength * (1 - dashFactor)) }
    
    public init(
        _ value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 0,
        outerDiameter: CGFloat = 300,
        lineWidth: CGFloat = 50,
        endDegrees: Double = 360,
        trackColor: Color = Color.blue,
        progressColor: Color = Color.green,
        dragCircleColor: Color = Color.black,
        isDashed: Bool = false,
        onValueChangeEnded: (() -> ())? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.outerDiameter = outerDiameter
        self.lineWidth = lineWidth
        self.endDegrees = endDegrees
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.dragCircleColor = dragCircleColor
        self.isDashed = isDashed
        self.onValueChangeEnded = onValueChangeEnded
    }
    
    public var body: some View {
        ZStack {
            if range.contains(value)
                && step >= 0
                && step <= rangeValue
                && outerDiameter > 0
                && outerDiameter > lineWidth
                && lineWidth > 0
                && endDegrees > 0
                && endDegrees <= 360 {
                //Track
                FWArc(endDegrees)
                    .strokeBorder(
                        AngularGradient(gradient: Gradient(colors: [.white, trackColor]), center: .center, startAngle: .zero, endAngle: .degrees(endDegrees)),
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            dash: getDashForTrack(),
                            dashPhase: getDashPhase()
                        )
                    )
                    .frame(width: outerDiameter, height: outerDiameter)
                    .rotationEffect(.init(degrees: 180))
                
                // Progress
                FWArc(endDegrees * progress)
                    .strokeBorder(
                        progressColor,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            dash: getDashForTrack(),
                            dashPhase: getDashPhase()
                        )
                    )
                    .frame(width: outerDiameter, height: outerDiameter)
                    .rotationEffect(.init(degrees: 180))
                
                // Drag Circle
                Circle()
                    .fill(dragCircleColor)
                    .frame(width: lineWidth, height: lineWidth)
                    .offset(x: (outerDiameter - lineWidth) / 2)
                    .rotationEffect(.init(degrees: dragCircleDegrees))
                    .gesture(
                        DragGesture()
                            .onChanged { dragAction($0) }
                            .onEnded { _ in onValueChangeEnded?() }
                    )
            }
        }
        .animation(.easeIn, value: value)
    }
    
    private func dragAction(_ dragValue: DragGesture.Value) {
        let dx = dragValue.location.x
        let dy = dragValue.location.y
        let radians = atan2(dy, dx)
        //angle value range is -180 to 180
        let angle = Double(radians * 180 / .pi)
        var temProgress = (angle + 180) / endDegrees
        //temProgress might be greater than 1 if endDegrees is less than 360
        if temProgress > 1 {
            temProgress = 1
        }
        if abs(progress - temProgress) < 0.5 {
            value = range.lowerBound + rangeValue * temProgress
            if step > 0 {
                value = round(value / step) * step
            }
        }
        else if progress > 0.9 {
            value = range.upperBound
        }
        else if progress < 0.1 {
            value = range.lowerBound
        }
    }
    
    private func getDragCircleDegrees() -> Double {
        var adjustProgress = progress
        if adjustProgress > 1 {
            adjustProgress = 1
        }
        else if adjustProgress < 0 {
            adjustProgress = 0
        }
        return endDegrees * adjustProgress - 180
    }
    
    private func getDashForTrack() -> [CGFloat] {
        isDashed && step > 0 ? [dashLength, gapLength] : [CGFloat]()
    }
    
    private func getDashPhase() -> CGFloat {
        dashLength / 2
    }
}
