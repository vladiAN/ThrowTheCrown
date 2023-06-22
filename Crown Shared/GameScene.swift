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

class GameScene: SKScene, SKPhysicsContactDelegate {
    var crowdOfPeople: [People] = []
    var princeArr: [People] = []
    var tappedKings: Set<SKSpriteNode> = []
    var crown: SKSpriteNode!
    var predictedKingCounter = 0
    var isInteractionEnabled = false
    
    let lineSpacing: CGFloat = 120
    let lineHeight: CGFloat = 5
    let kingSpacing: CGFloat = 55
    let scaleFactor: CGFloat = 0.08
    
    let crownImpulseXSlider = Slider(length: 130, isHorizontal: false)
    let crownImpulseYSlider = Slider(length: 130, isHorizontal: false)
    let crownRotationSlider = Slider(length: 100, isHorizontal: true)
    var impulseVector: CGVector = .zero
    
    var restartButton: SKSpriteNode!
    
    
    
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
        addRestartButton()
        
    }
    
    func setupBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundNode.zPosition = -1
        backgroundNode.size = self.size
        addChild(backgroundNode)
    }
    
    func addPrincess() {
        let princess = SKSpriteNode(imageNamed: "princess")
        princess.setScale(0.3)
        princess.position = CGPoint(x: frame.midX * 1.7, y: frame.midY - princess.frame.height / 4)
        addChild(princess)
    }
    
    func addCrown() {
        crown = SKSpriteNode(imageNamed: "crown")
        crown.size = CGSize(width: 60, height: 40)
        crown.position = CGPoint(x: frame.midX * 1.4, y: frame.midY)
        addChild(crown)
        
        crown.physicsBody = SKPhysicsBody(rectangleOf: crown.size)
        crown.physicsBody?.isDynamic = true
        crown.physicsBody?.affectedByGravity = false
        crown.physicsBody?.collisionBitMask = 0
        
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
        
        let restoreTimerInterval = 2.0
        let restoreAction = SKAction.wait(forDuration: restoreTimerInterval)
        let restoreTextureAction = SKAction.run { [weak self] in
            self?.restorePeopleTextures()
            self?.exchangePeoplePositions()
        }
        let restoreSequenceAction = SKAction.sequence([restoreAction, restoreTextureAction])
        run(restoreSequenceAction)
    }
    
    func impulseApplication() {
        crown.physicsBody?.applyImpulse(impulseVector)
        crown.physicsBody?.affectedByGravity = true
        crown.physicsBody?.applyAngularImpulse(0.05)
    }
    
    func addRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart_button")
        restartButton.position = CGPoint(x: frame.midX * 1.4, y: frame.midY - crown.frame.height)
        restartButton.size = CGSize(width: 50, height: 50)
        restartButton.zPosition = 10
        addChild(restartButton)
    }
    
    func restartCrown() {
        crown.position = CGPoint(x: frame.midX * 1.4, y: frame.midY)
        crown.zRotation = 0
        crown.physicsBody?.velocity = .zero
        crown.physicsBody?.angularVelocity = 0
        crown.physicsBody?.affectedByGravity = false
    }
    
    func createNodeForCrown() {
                
        let leftStoppedCrownNode = SKNode()
        let rightStoppedCrownNode = SKNode()
        let centerFixationCrownNode = SKNode()
        
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
        centerFixationCrownNode.position = CGPoint(x: crown.position.x, y: crown.position.y)
        
        addChild(centerFixationCrownNode)
        let jointCenter = SKPhysicsJointFixed.joint(withBodyA: crown.physicsBody!, bodyB: centerFixationCrownNode.physicsBody!, anchor: centerFixationCrownNode.position)
        self.physicsWorld.add(jointCenter)
        


    }
    
    
}




