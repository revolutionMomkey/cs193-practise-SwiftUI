//
//  Cardify.swift
//  Memorize
//
//  Created by 杜俊楠 on 2022/7/25.
//  Copyright © 2022 杜俊楠. All rights reserved.
//

import SwiftUI


struct Cardify: AnimatableModifier {
//    var isFaceUp: Bool
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0:180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double //in degress
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstans.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth:DrawingConstans.lienWidth)
            }
            else {
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1:0)
        }
        .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    private struct DrawingConstans {
        static let cornerRadius: CGFloat = 10
        static let lienWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
