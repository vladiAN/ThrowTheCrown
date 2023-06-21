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
            prince.run(sequenceAction)
            createPhysicsForPrince(position: prince.position)
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
    
    func createPhysicsForPrince(position: CGPoint) {
        let nodeFixationCrown = SKNode()
        let nodeStoppedCrown = SKNode()
        
        let nodeFixationSize = CGSize(width: 10, height: 50)
        let nodeStoppedSize = CGSize(width: crown.frame.width, height: 5)
                
        let nodeFixationPhysicsBody = SKPhysicsBody(rectangleOf: nodeFixationSize)
        nodeFixationPhysicsBody.affectedByGravity = false
        nodeFixationPhysicsBody.isDynamic = false
        nodeFixationCrown.physicsBody = nodeFixationPhysicsBody
        
        let nodeStoppedPhysicsBody = SKPhysicsBody(rectangleOf: nodeStoppedSize)
        nodeStoppedPhysicsBody.affectedByGravity = false
        nodeStoppedPhysicsBody.isDynamic = false
        nodeStoppedCrown.physicsBody = nodeStoppedPhysicsBody
        
        addChild(nodeStoppedCrown)
//        addChild(nodeFixationCrown)
        
        nodeStoppedCrown.position = position
        nodeFixationCrown.position = CGPoint(x: position.x, y: position.y + nodeFixationCrown.frame.height / 2)
        print(position.y, position.y + nodeFixationCrown.frame.height / 2)
    }


    
}
