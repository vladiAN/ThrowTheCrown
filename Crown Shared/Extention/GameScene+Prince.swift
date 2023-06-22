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
            
            let newSize = CGSize(width: people.size.width * scaleFactor, height: people.size.height * scaleFactor)
            people.scale(to: newSize)
            
            let peopleXPosition = startX + CGFloat(i) * kingSpacing
            let peopleYPosition: CGFloat = 40
            people.position = CGPoint(x: peopleXPosition, y: peopleYPosition)
            line.addChild(people)
            people.move(toParent: self)
            
            crowdOfPeople.append(people)
        }
    }
    
    func changeRandomPeopleTextures() {
        let randomPrinceCount = 3
        let numberOfPeople = crowdOfPeople.count
        
        var randomIndexes = Set<Int>()
        while randomIndexes.count < randomPrinceCount {
            let randomIndex = Int.random(in: 0..<numberOfPeople)
            randomIndexes.insert(randomIndex)
        }
        
        for index in randomIndexes {
            let prince = crowdOfPeople[index]
            let newTexture = SKTexture(imageNamed: "king")
            prince.texture = newTexture
            princeArr.append(prince)
        }
    }
    
    func restorePeopleTextures() {
        for people in crowdOfPeople {
            let originalTexture = SKTexture(imageNamed: "not_king")
            people.texture = originalTexture
        }
    }
    
    func exchangePeoplePositions() {
        isInteractionEnabled = false
        var arrAct:[SKAction] = []
        for i in 0 ... crowdOfPeople.count - 1 {
            var randIndex = Int.random(in: 0 ... crowdOfPeople.count - 1)
            while randIndex == i {
                randIndex = Int.random(in: 0 ... crowdOfPeople.count - 1)
            }
            let currentPrince = crowdOfPeople[i]
            let peopleToSwap = crowdOfPeople[randIndex]
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
            let scaleAction = SKAction.scale(to: 0.3, duration: 0.3)
            let sequenceAction = SKAction.sequence([moveAction, scaleAction])
            prince.run(sequenceAction) {
                self.createNodeStoppedCrownAbovePrince(prince)
            }
        }
        
        for people in crowdOfPeople {
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
        let nodeStoppedCrown = SKNode()
        let nodeFixationCrown = SKNode()
        
        let nodeStoppedSize = CGSize(width: crown.frame.width + 30, height: 5)
        nodeStoppedCrown.position = CGPoint(x: prince.position.x, y: prince.position.y + prince.frame.height / 3)
        nodeStoppedCrown.zPosition = prince.zPosition + 1
        
        let nodeFixationSize = CGSize(width: 10, height: crown.frame.height / 1.5)
        nodeFixationCrown.position = CGPoint(x: prince.position.x, y: nodeStoppedCrown.position.y + nodeStoppedSize.height / 2 + nodeFixationSize.height / 2)
        nodeFixationCrown.zPosition = prince.zPosition + 1
        
        let nodeStoppedPhysicsBody = SKPhysicsBody(rectangleOf: nodeStoppedSize)
        nodeStoppedPhysicsBody.affectedByGravity = false
        nodeStoppedPhysicsBody.isDynamic = false
        nodeStoppedCrown.physicsBody = nodeStoppedPhysicsBody
        nodeStoppedCrown.physicsBody?.collisionBitMask = 1
        nodeStoppedCrown.physicsBody?.restitution = 0.0
        nodeStoppedCrown.physicsBody?.categoryBitMask = BitMasks.nodeStoppedCrown
        
        let nodeFixationPhysicsBody = SKPhysicsBody(rectangleOf: nodeFixationSize)
        nodeFixationPhysicsBody.affectedByGravity = false
        nodeFixationPhysicsBody.isDynamic = false
        nodeFixationCrown.physicsBody = nodeFixationPhysicsBody
        nodeFixationCrown.physicsBody?.collisionBitMask = 1
        nodeFixationCrown.physicsBody?.restitution = 0.0
        nodeFixationCrown.physicsBody?.categoryBitMask = BitMasks.nodeFixationCrown
        
        addChild(nodeStoppedCrown)
        addChild(nodeFixationCrown)
        
    }
    
    
    
    
    
    
}
