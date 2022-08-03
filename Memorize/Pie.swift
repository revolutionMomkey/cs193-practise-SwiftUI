//
//  Pie.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/7/24.
//  Copyright © 2022 杜俊楠. All rights reserved.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool = false
    
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height)/2
        let start = CGPoint (
            x:center.x + radius * cos(startAngle.radians),
            y:center.y + radius * sin(startAngle.radians)
        )
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockWise)
        p.addLine(to: center)
        
        return p
    }
    
    
    
}
