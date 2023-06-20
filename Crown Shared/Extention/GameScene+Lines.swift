//
//  GameScene+Lines.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import Foundation

extension GameScene {
    
    func createVerticalLines() {
        let numberOfLines = 3
        let startX = size.width / 4
        
        for i in 0..<numberOfLines {
            let line = LineNode(rectOfSize: CGSize(width: size.height / 1.5, height: lineHeight))
            let lineYPosition = size.height / 2.3 + CGFloat(i - 1) * lineSpacing
            line.name = "kingLine"
            line.position = CGPoint(x: startX, y: lineYPosition)
            addChild(line)
            createPeople(on: line)
        }
    }
}
