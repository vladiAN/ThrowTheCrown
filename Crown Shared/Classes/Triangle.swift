//
//  Triangle.swift
//  Crown
//
//  Created by Vladislav Andrushok on 25.06.2023.
//

import Foundation
import SpriteKit

class EquilateralTriangleNode: SKShapeNode {
    init(hypotenuseLength: CGFloat) {
        super.init()
        self.path = createTrianglePath(hypotenuseLength: hypotenuseLength).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTrianglePath(hypotenuseLength: CGFloat) -> UIBezierPath {
        let sideLength = hypotenuseLength / sqrt(2)
        let halfSideLength = sideLength / 2
        let height = sideLength / 2 * sqrt(3)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -halfSideLength, y: -height / 2))
        path.addLine(to: CGPoint(x: halfSideLength, y: -height / 2))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.close()
        
        return path
    }
}
