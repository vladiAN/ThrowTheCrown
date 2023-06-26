//
//  GameScene+Lines.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import Foundation
import SpriteKit

extension GameScene {
    
    
    func createVerticalLines() {
        let numberOfParalelsLines = 3
        let startX = size.width / 3
        var firstLineYPosition: CGFloat = 0
        
        for i in 0..<numberOfParalelsLines {
            let line = LineNode(rectOfSize: CGSize(width: size.height / 1.5, height: lineHeight))
            let lineYPosition = size.height / 2.3 + CGFloat(i - 1) * lineSpacing
            line.name = "kingLine"
            line.zPosition = 1
            line.fillColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
            line.strokeColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
            line.position = CGPoint(x: startX, y: lineYPosition)
            if i == 0 {
                firstLineYPosition = line.position.y
                print(firstLineYPosition)
            }
            addChild(line)
            createPeople(on: line)
        }

        let lineLeft = SKShapeNode(rectOf: CGSize(width: lineHeight, height: size.height))
        lineLeft.zPosition = 1
        lineLeft.fillColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
        lineLeft.strokeColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
        lineLeft.name = "kingLine"
        lineLeft.position = CGPoint(x: startX - lineHeight / 2 - size.height / 1.5 / 2,
                                    y: firstLineYPosition + lineLeft.frame.height / 2 - lineHeight + 1)
        addChild(lineLeft)
        
        let lineRight = SKShapeNode(rectOf: CGSize(width: lineHeight, height: size.height))
        lineRight.zPosition = 1
        lineRight.fillColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
        lineRight.strokeColor = #colorLiteral(red: 0.5921568627, green: 0.3529411765, blue: 0.07058823529, alpha: 1)
        lineRight.name = "kingLine"
        lineRight.position = CGPoint(x: startX + lineHeight / 2 + size.height / 1.5 / 2,
                                     y: firstLineYPosition + lineRight.frame.height / 2 - lineHeight + 1)
        addChild(lineRight)
        
        let backGroundLines = SKShapeNode(rectOf: CGSize(width: size.height / 1.5, height: size.height))
        backGroundLines.zPosition = 0
        backGroundLines.fillColor = #colorLiteral(red: 0.3058823529, green: 0.1921568627, blue: 0.05882352941, alpha: 1)
        backGroundLines.strokeColor = #colorLiteral(red: 0.3058823529, green: 0.1921568627, blue: 0.05882352941, alpha: 1)
        backGroundLines.name = "kingLine"
        backGroundLines.position = CGPoint(x: startX, y: firstLineYPosition + backGroundLines.frame.height / 2)
        addChild(backGroundLines)

    }
}
