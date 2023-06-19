//
//  GameScene+King.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import SpriteKit

extension GameScene {
    
    func createKings(on line: SKShapeNode) {
        let numberOfKingsInLine = 5
        let totalSpacing = CGFloat(numberOfKingsInLine - 1) * kingSpacing
        let startX = -(totalSpacing / 2)
        
        for i in 0..<numberOfKingsInLine {
            let king = King()
            
            let newSize = CGSize(width: king.size.width * scaleFactor, height: king.size.height * scaleFactor)
            king.scale(to: newSize)
            
            let kingXPosition = startX + CGFloat(i) * kingSpacing
            let kingYPosition: CGFloat = 40
            king.position = CGPoint(x: kingXPosition, y: kingYPosition)
            line.addChild(king)
            king.move(toParent: self)
            
            kings.append(king)
        }
    }
    
    func changeRandomKingTextures() {
        let randomKingCount = 3
        let numberOfKings = kings.count
        
        var randomIndexes = Set<Int>()
        while randomIndexes.count < randomKingCount {
            let randomIndex = Int.random(in: 0..<numberOfKings)
            randomIndexes.insert(randomIndex)
        }
        
        for index in randomIndexes {
            let king = kings[index]
            let newTexture = SKTexture(imageNamed: "king")
            king.texture = newTexture
            
            kingsToChange.append(king)
        }
    }
    
    func restoreKingTextures() {
        for king in kings {
            let originalTexture = SKTexture(imageNamed: "not_king")
            king.texture = originalTexture
        }
    }
    
    func exchangeKingPositions() {
        isInteractionEnabled = false
        var arrAct:[SKAction] = []
        for i in 0 ... kings.count - 1 {
            var randIndex = Int.random(in: 0 ... kings.count - 1)
            while randIndex == i {
                randIndex = Int.random(in: 0 ... kings.count - 1)
            }
            let currentKing = kings[i]
            let kingToSwap = kings[randIndex]
            arrAct.append(.run {
                currentKing.run(.move(to: kingToSwap.position, duration: 0.3))
                kingToSwap.run(.move(to: currentKing.position, duration: 0.3))
            })
            arrAct.append(.wait(forDuration: 0.5))
        }
        self.run(.sequence(arrAct)) {
            self.isInteractionEnabled = true
        }
    }
    
    func arrangeKingsInCenter() {
        let centerPoint = CGPoint(x: size.width / 5, y: size.height / 2)
        let kingSpacing = kingSpacing
        
        let totalWidth = CGFloat(kingsToChange.count - 1) * kingSpacing
        
        let startX = centerPoint.x - totalWidth / 4
        
        for (index, king) in kingsToChange.enumerated() {
            let kingXPosition = startX + CGFloat(index) * kingSpacing
            let moveAction = SKAction.move(to: CGPoint(x: kingXPosition, y: centerPoint.y), duration: 0.3)
            let scaleAction = SKAction.scale(to: 0.4, duration: 0.3)
            let groupAction = SKAction.group([moveAction, scaleAction])
            king.run(groupAction)
        }
    }
    
}
