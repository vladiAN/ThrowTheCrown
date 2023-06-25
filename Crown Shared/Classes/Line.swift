//
//  Line.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import SpriteKit

class LineNode: SKShapeNode {
    
    let lineHeight: CGFloat = 5
    
    init(rectOfSize size: CGSize) {
        super.init()
        let lineRect = CGRect(x: -size.width / 2, y: -lineHeight / 2, width: size.width, height: lineHeight)
        path = CGPath(rect: lineRect, transform: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
