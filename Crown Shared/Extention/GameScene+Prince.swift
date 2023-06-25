//
//  GameScene+Prince.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import SpriteKit

extension GameScene {
    
    func createPeople(on line: SKShapeNode) {
        let numberOfPeopleInLine = 5
        let totalSpacing = CGFloat(numberOfPeopleInLine - 1) * kingSpacing
        let startX = -(totalSpacing / 2)
        
        for i in 0..<numberOfPeopleInLine {
            let people = People()
            let peopleTextureName = "not_king\(Int.random(in: 1...2))"
            peopleTextureNameArr.append(peopleTextureName)
            people.texture = SKTexture(imageNamed: peopleTextureName)
                        
            let newSize = CGSize(width: people.size.width * scaleFactor, height: people.size.height * scaleFactor)
            people.scale(to: newSize)
            
            let peopleXPosition = startX + CGFloat(i) * kingSpacing
            let peopleYPosition: CGFloat = 40
            people.zPosition = 3
            people.position = CGPoint(x: peopleXPosition, y: peopleYPosition)
            line.addChild(people)
            people.move(toParent: self)
            
            peopleArr.append(people)
        }
    }
    
    func changeRandomPeopleTextures() {
        let randomPrinceCount = 3
        let numberOfPeople = peopleArr.count
        
        var randomIndexes = Set<Int>()
        while randomIndexes.count < randomPrinceCount {
            let randomIndex = Int.random(in: 0..<numberOfPeople)
            randomIndexes.insert(randomIndex)
        }
        
        for index in randomIndexes {
            let prince = peopleArr[index]
            let newTexture = SKTexture(imageNamed: "king")
            prince.texture = newTexture
            princeArr.append(prince)
        }
    }
    
    func restorePeopleTextures() {
        for (index, people) in peopleArr.enumerated() {
            let originalTexture = SKTexture(imageNamed: peopleTextureNameArr[index])
            people.texture = originalTexture
        }
    }
    
    func exchangePeoplePositions() {
        isInteractionEnabled = false
        var arrAct:[SKAction] = []
        for i in 0 ... peopleArr.count - 1 {
            var randIndex = Int.random(in: 0 ... peopleArr.count - 1)
            while randIndex == i {
                randIndex = Int.random(in: 0 ... peopleArr.count - 1)
            }
            let currentPrince = peopleArr[i]
            let peopleToSwap = peopleArr[randIndex]
            arrAct.append(.run {
                currentPrince.run(.move(to: peopleToSwap.position, duration: 0.3))
                peopleToSwap.run(.move(to: currentPrince.position, duration: 0.3))
            })
            arrAct.append(.wait(forDuration: 0.5))
        }
        self.run(.sequence(arrAct)) {
            self.isInteractionEnabled = true
        }
    }
    
    func arrangePrinceInCenter() {
        let centerPoint = CGPoint(x: size.width / 4, y: size.height / 2.5)
        let princeSpacing: CGFloat = 90
        
        let totalWidth = CGFloat(princeArr.count - 1) * princeSpacing
        
        let startX = centerPoint.x - totalWidth / 2
        
        for (index, prince) in princeArr.enumerated() {
            let princeXPosition = startX + CGFloat(index) * princeSpacing
            prince.zPosition = CGFloat(index + 1)
            let moveAction = SKAction.move(to: CGPoint(x: princeXPosition, y: centerPoint.y), duration: 0.3)
            let scaleAction = SKAction.scale(to: 0.22, duration: 0.3)
            let sequenceAction = SKAction.sequence([moveAction, scaleAction])
            prince.run(sequenceAction) {
            }
        }
        
        for people in peopleArr {
            if !princeArr.contains(people) {
                people.removeFromParent()
            }
        }
        
        for child in children {
            if let line = child as? SKShapeNode, line.name == "kingLine" {
                line.removeFromParent()
            }
        }
        
        
    }
    
    
    func createNodeStoppedCrownAbovePrince(_ prince: SKSpriteNode) {
        
        let nodeStoppedWidth: CGFloat = crown.frame.width * 1.2
        let nodeStoppedCrown = EquilateralTriangleNode(hypotenuseLength: nodeStoppedWidth)
        nodeStoppedCrown.position = CGPoint(x: prince.position.x, y: prince.position.y + prince.frame.height / 2)
//        nodeStoppedCrown.zPosition = prince.zPosition + 1
        
        let nodeStoppedPhysicsBody = SKPhysicsBody(polygonFrom: nodeStoppedCrown.path!)
        nodeStoppedPhysicsBody.affectedByGravity = false
        nodeStoppedPhysicsBody.isDynamic = false
        nodeStoppedCrown.physicsBody = nodeStoppedPhysicsBody
        nodeStoppedCrown.physicsBody?.restitution = 0
        nodeStoppedCrown.physicsBody?.categoryBitMask = BitMasks.nodeFixationCrown
        nodeStoppedCrown.physicsBody?.contactTestBitMask = BitMasks.centerFixationCrownNode
        
        addChild(nodeStoppedCrown)
    }
    
    
    
    
    
}
