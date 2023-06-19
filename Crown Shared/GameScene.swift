//
//  GameScene.swift
//  Crown Shared
//
//  Created by Vladislav Andrushok on 16.06.2023.
//

import SpriteKit

class GameScene: SKScene {
    var kings: [SKSpriteNode] = []
    var kingsToChange: [SKSpriteNode] = []
    
    let lineSpacing: CGFloat = 120
    let lineHeight: CGFloat = 5
    let kingSpacing: CGFloat = 55
    let scaleFactor: CGFloat = 0.08
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .green
        createVerticalLines()
        startRandomTextureTimer()
    }
    
    func createVerticalLines() {
        let numberOfLines = 3
        let startX = size.width / 4
        
        for i in 0..<numberOfLines {
            let line = SKShapeNode(rectOf: CGSize(width: size.height / 1.5, height: lineHeight))
            let lineYPosition = size.height / 2.3 + CGFloat(i - 1) * lineSpacing
            line.position = CGPoint(x: startX, y: lineYPosition)
            line.fillColor = .white
            line.strokeColor = .white
            addChild(line)
            createKings(on: line)
        }
    }
    
    func createKings(on line: SKShapeNode) {
        let numberOfKingsInLine = 5
        let totalSpacing = CGFloat(numberOfKingsInLine - 1) * kingSpacing
        let startX = -(totalSpacing / 2)
        
        for i in 0..<numberOfKingsInLine {
            let kingTexture = SKTexture(imageNamed: "not_king")
            let king = SKSpriteNode(texture: kingTexture)
            
            let newSize = CGSize(width: kingTexture.size().width * scaleFactor, height: kingTexture.size().height * scaleFactor)
            king.scale(to: newSize)
            
            let kingXPosition = startX + CGFloat(i) * kingSpacing
            let kingYPosition: CGFloat = 40
            king.position = CGPoint(x: kingXPosition, y: kingYPosition)
            king.name = "king"
            line.addChild(king)
            
            kings.append(king)
        }
    }
    
    func startRandomTextureTimer() {
        let timerInterval = 1.0
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] _ in
            self?.changeRandomKingTextures()
        }
        
        let restoreTimerInterval = 2.0
        Timer.scheduledTimer(withTimeInterval: restoreTimerInterval, repeats: false) { [weak self] _ in
            self?.restoreKingTextures()
        }
    }
    
    func changeRandomKingTextures() {
        let randomKingCount = 1
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
        let numberOfKings = kings.count
        
        for kingToChange in kingsToChange {
            var kingToSwap = kingToChange
            var swapPosition = kingToSwap.position
            
            while swapPosition == kingToChange.position {
                let randomIndex = Int.random(in: 0..<numberOfKings)
                kingToSwap = kings[randomIndex]
                swapPosition = kingToSwap.position
            }
            
            let tempPosition = kingToChange.position
            print(tempPosition, swapPosition)
            
            let moveAction1 = SKAction.move(to: swapPosition, duration: 1)
            let moveAction2 = SKAction.move(to: tempPosition, duration: 1)
            
            kingToChange.run(moveAction1)
            kingToSwap.run(moveAction2)
        }
        kingsToChange.removeAll()
    }
    
    
}




