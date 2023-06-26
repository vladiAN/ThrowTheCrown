//
//  GameScene.swift
//  Crown Shared
//
//  Created by Vladislav Andrushok on 16.06.2023.
//

import UIKit
import SpriteKit

struct BitMasks {
    static let nodeStoppedCrown: UInt32 = 1
    static let nodeFixationCrown: UInt32 = 2
    static let centerFixationCrownNode: UInt32 = 4
    static let sideStoppers: UInt32 = 8
}

class GameScene: SKScene {
    var peopleArr: [People] = []
    var princeArr: [People] = []
    var peopleTextureNameArr: [String] = []
    var tappedKings: Set<SKSpriteNode> = []
    var crown: SKSpriteNode!
    var princess: SKSpriteNode!
    var predictedKingCounter = 0
    var isInteractionEnabled = false
    
    let lineSpacing: CGFloat = 120
    let lineHeight: CGFloat = 5
    let kingSpacing: CGFloat = 55
    let scaleFactor: CGFloat = 0.06
    
    let crownImpulseXSlider = Slider(length: 130, isHorizontal: false, backgroundColor: .xSlider)
    let crownImpulseYSlider = Slider(length: 130, isHorizontal: false, backgroundColor: .ySlider)
    let crownRotationSlider = Slider(length: 100, isHorizontal: true, backgroundColor: .rotationSlider)
    var rotationAngleForCrown: CGFloat = 0
    var impulseVector: CGVector = .zero
    
    var contactTimer: Timer?
    var isContactOngoing = false
    var isPhysicsBodyPrinceCreated = false
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.scaleMode = .aspectFill
        
        self.physicsWorld.contactDelegate = self
        
        setupBackground()
        addPrincess()
        addCrown()
        createVerticalLines()
        startRandomTextureTimer()
        addCrownImpulseXSlider()
        addCrownImpulseYSlider()
        addCrownRotationSlider()
        
    }
    
    func setupBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundNode.zPosition = -1
        backgroundNode.size = self.size
        addChild(backgroundNode)
    }
    
    func addPrincess() {
        let princessTexture = SKTexture(imageNamed: "princess 1")
        princess = SKSpriteNode(texture: princessTexture)
        princess.setScaleByHeight(newHeight: 350)
        princess.position = CGPoint(x: frame.midX * 1.6, y: frame.midY - princess.frame.height / 5)
        addChild(princess)
    }
    
    func animatePrincess() {
        let princessAnimateTexture = [
            SKTexture(imageNamed: "princess 1"),
            SKTexture(imageNamed: "princess 3"),
            SKTexture(imageNamed: "princess 3"),
            SKTexture(imageNamed: "princess 1")
        ]
        let princessAnimation = SKAction.animate(with: princessAnimateTexture, timePerFrame: 0.1)
        princess.run(princessAnimation)
    }
    
    func addCrown() {
        crown = SKSpriteNode(imageNamed: "3crown")
        crown.size = CGSize(width: 60, height: 40)
        crown.position = CGPoint(x: frame.midX * 1.32, y: princess.position.y + crown.frame.height)
        addChild(crown)
        
        crown.physicsBody = SKPhysicsBody(rectangleOf: crown.size)
        crown.physicsBody?.isDynamic = false
        crown.physicsBody?.affectedByGravity = false
        crown.physicsBody?.collisionBitMask = 0
        crown.physicsBody?.restitution = 0
        
        createNodeForCrown()
        
    }
    
    func startRandomTextureTimer() {
        let timerInterval = 1.0
        let waitAction = SKAction.wait(forDuration: timerInterval)
        let changeTextureAction = SKAction.run { [weak self] in
            self?.changeRandomPeopleTextures()
        }
        let sequenceAction = SKAction.sequence([waitAction, changeTextureAction])
        run(sequenceAction)
        
        let restoreTimerInterval = 3.0
        let restoreAction = SKAction.wait(forDuration: restoreTimerInterval)
        let restoreTextureAction = SKAction.run { [weak self] in
            self?.restorePeopleTextures()
            self?.exchangePeoplePositions()
        }
        let restoreSequenceAction = SKAction.sequence([restoreAction, restoreTextureAction])
        run(restoreSequenceAction)
    }
    
    func impulseApplication() {
        crown.physicsBody?.isDynamic = true
        crown.physicsBody?.applyImpulse(impulseVector)
        crown.physicsBody?.affectedByGravity = true
        crown.physicsBody?.applyAngularImpulse(0.05)
    }
    
    func restartCrown() {
        crown.physicsBody?.isDynamic = false
        crown.physicsBody?.affectedByGravity = false
        crown.zPosition = 10
        crown.zRotation = rotationAngleForCrown
        crown.physicsBody?.velocity = CGVector.zero
        crown.physicsBody?.angularVelocity = 0
        crown.position = CGPoint(x: frame.midX * 1.32, y: princess.position.y + crown.frame.height)
    }
    
    func createNodeForCrown() {
        
        let leftStoppedCrownNode = SKNode()
        leftStoppedCrownNode.name = "stoppedCrownNode"
        let rightStoppedCrownNode = SKNode()
        rightStoppedCrownNode.name = "stoppedCrownNode"
        let centerFixationCrownNode = SKNode()
        centerFixationCrownNode.name = "fixationCrownNode"
        
        let stoppedCrownNodeSize = CGSize(width: 10, height: crown.frame.height)
        let centerFixationCrownNodeSize = CGSize(width: crown.frame.width / 2, height: crown.frame.height / 1.5)
        
        
        let leftStoppedPhysicsBody = SKPhysicsBody(rectangleOf: stoppedCrownNodeSize)
        leftStoppedPhysicsBody.affectedByGravity = false
        leftStoppedPhysicsBody.isDynamic = true
        leftStoppedCrownNode.physicsBody = leftStoppedPhysicsBody
        //        leftStoppedCrownNode.physicsBody?.collisionBitMask = 0
        leftStoppedCrownNode.physicsBody?.restitution = 0.0
        leftStoppedCrownNode.physicsBody?.categoryBitMask = BitMasks.sideStoppers
        leftStoppedCrownNode.position = CGPoint(x: crown.position.x - crown.frame.width / 2 + stoppedCrownNodeSize.width / 2, y: crown.position.y)
        
        addChild(leftStoppedCrownNode)
        let jointLeft = SKPhysicsJointFixed.joint(withBodyA: crown.physicsBody!, bodyB: leftStoppedCrownNode.physicsBody!, anchor: leftStoppedCrownNode.position)
        self.physicsWorld.add(jointLeft)
        
        let rightStoppedPhysicsBody = SKPhysicsBody(rectangleOf: stoppedCrownNodeSize)
        rightStoppedPhysicsBody.affectedByGravity = false
        rightStoppedPhysicsBody.isDynamic = true
        rightStoppedCrownNode.physicsBody = rightStoppedPhysicsBody
        //        rightStoppedCrownNode.physicsBody?.collisionBitMask = 0
        rightStoppedCrownNode.physicsBody?.restitution = 0.0
        rightStoppedCrownNode.physicsBody?.categoryBitMask = BitMasks.sideStoppers
        rightStoppedCrownNode.position = CGPoint(x: crown.position.x + crown.frame.width / 2 - stoppedCrownNodeSize.width / 2, y: crown.position.y)
        
        addChild(rightStoppedCrownNode)
        let jointRight = SKPhysicsJointFixed.joint(withBodyA: crown.physicsBody!, bodyB: rightStoppedCrownNode.physicsBody!, anchor: rightStoppedCrownNode.position)
        self.physicsWorld.add(jointRight)
        
        let centerFixationPhysicsBody = SKPhysicsBody(rectangleOf: centerFixationCrownNodeSize)
        centerFixationPhysicsBody.affectedByGravity = false
        centerFixationPhysicsBody.isDynamic = true
        centerFixationCrownNode.physicsBody = centerFixationPhysicsBody
        centerFixationCrownNode.physicsBody?.collisionBitMask = 0
        centerFixationCrownNode.physicsBody?.categoryBitMask = BitMasks.centerFixationCrownNode
        centerFixationCrownNode.physicsBody?.contactTestBitMask = BitMasks.nodeFixationCrown
        centerFixationCrownNode.position = CGPoint(x: crown.position.x, y: crown.position.y)
        
        addChild(centerFixationCrownNode)
        let jointCenter = SKPhysicsJointFixed.joint(withBodyA: crown.physicsBody!, bodyB: centerFixationCrownNode.physicsBody!, anchor: centerFixationCrownNode.position)
        self.physicsWorld.add(jointCenter)
        
    }
    
    func addConfetti() {
        let confetti = SKEmitterNode(fileNamed: "Confetti")!
        confetti.position = CGPoint(x: frame.midX, y: frame.maxY)
        confetti.zPosition = 5
        addChild(confetti)
    }
    
    func successfulRoll() {
        let nodesToRemove = children.filter { $0.name == "stoppedCrownNode" || $0.name == "fixationCrownNode" || $0.name == "nodeStoppedCrown" }
        
        if let lastPrince = princeArr.last {
            princeArr.removeLast()
            let scaleAction = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([scaleAction, removeAction])
            
            lastPrince.run(sequenceAction)
        }
        
        let crownScaleAction = SKAction.fadeAlpha(to: 0.0, duration: 0.5)
        let removeNodeAction = SKAction.run {
            nodesToRemove.forEach { $0.removeFromParent() }
        }
        let crownRemoveAction = SKAction.removeFromParent()
        let crownSequenceAction = SKAction.sequence([crownScaleAction, removeNodeAction, crownRemoveAction])
        
        crown.run(crownSequenceAction)
        
        self.addCrown()
        if let newPrince = princeArr.last {
            self.createNodeStoppedCrownAbovePrince(newPrince)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if crown.position.y < 0 {
            restartCrown()
        }
    }
    
    
    
}


extension SKNode {
  func setScaleByHeight(newHeight: CGFloat) {
    let newScale = self.xScale * newHeight/self.frame.height
    self.setScale(newScale)
  }
}

