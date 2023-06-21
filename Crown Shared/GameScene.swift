//
//  GameScene.swift
//  Crown Shared
//
//  Created by Vladislav Andrushok on 16.06.2023.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
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
        self.scaleMode = .aspectFill
        
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
        crown.setScale(0.13)
        crown.position = CGPoint(x: frame.midX * 1.4, y: frame.midY)
        addChild(crown)
        
        crown.physicsBody = SKPhysicsBody(rectangleOf: crown.size)
        crown.physicsBody?.isDynamic = true
        crown.physicsBody?.affectedByGravity = false
        
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
    
    func addCrownImpulseXSlider() {
        let sliderXPosition = frame.midX * 1.85
        let sliderYPosition = frame.midY + crownImpulseXSlider.frame.height / 1.6
        
        crownImpulseXSlider.slidingHandler = { data in
            self.impulseVector.dx = -300 * (data + 1) / 2
        }
        
        crownImpulseXSlider.position = CGPoint(x: sliderXPosition, y: sliderYPosition)
        addChild(crownImpulseXSlider)
    }
    
    func addCrownImpulseYSlider() {
        let sliderXPosition = frame.midX * 1.85
        let sliderYPosition = frame.midY - crownImpulseYSlider.frame.height / 1.6
        
        crownImpulseYSlider.slidingHandler = { data in
            self.impulseVector.dy = 300 * (data + 1) / 2
        }
        
        crownImpulseYSlider.position = CGPoint(x: sliderXPosition, y: sliderYPosition)
        addChild(crownImpulseYSlider)
    }
    
    func impulseApplication() {
        crown.physicsBody?.applyImpulse(impulseVector)
        crown.physicsBody?.affectedByGravity = true
        crown.physicsBody?.applyAngularImpulse(0.05)
    }
    
    func addCrownRotationSlider() {
        let sliderXPosition = frame.midX * 1.65
        let sliderYPosition = frame.minY + crownRotationSlider.frame.height * 2.7
        
        crownRotationSlider.slidingHandler = { data in
            let maxRotationAngle: CGFloat = .pi
            let rotationAngle = data * maxRotationAngle
            
            self.crown.zRotation = rotationAngle
        }
        
        crownRotationSlider.position = CGPoint(x: sliderXPosition, y: sliderYPosition)
        addChild(crownRotationSlider)
        
        crownRotationSlider.scrollCenter.position.x = 0
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
    
    
    
    
}




