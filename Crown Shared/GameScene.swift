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
    
    var crownImpulseXSlider: UISlider!
    var crownImpulseYSlider: UISlider!
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        
        setupBackground()
        addPrincess()
        addCrown()
        createVerticalLines()
        startRandomTextureTimer()
        addCrownImpulseXSlider()
        addCrownImpulseYSlider()
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
        crown.setScale(0.15)
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
        let sliderWidth: CGFloat = 150
        let sliderHeight: CGFloat = 20
        let sliderXPosition = frame.midX * 1.7
        let sliderYPosition = frame.midY - sliderWidth / 2
        let sliderFrame = CGRect(x: sliderXPosition, y: sliderYPosition, width: sliderWidth, height: sliderHeight)
        
        crownImpulseXSlider = UISlider(frame: sliderFrame)
        crownImpulseXSlider.minimumValue = 0
        crownImpulseXSlider.maximumValue = 300
        crownImpulseXSlider.value = 50
        crownImpulseXSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        crownImpulseXSlider.minimumTrackTintColor = UIColor.red

        self.view!.addSubview(crownImpulseXSlider)
    }
    
    func addCrownImpulseYSlider() { //DRY????
        let sliderWidth: CGFloat = 150
        let sliderHeight: CGFloat = 20
        let sliderXPosition = frame.midX * 1.7
        let sliderYPosition = frame.midY + sliderWidth / 2
        let sliderFrame = CGRect(x: sliderXPosition, y: sliderYPosition, width: sliderWidth, height: sliderHeight)
        
        crownImpulseYSlider = UISlider(frame: sliderFrame)
        crownImpulseYSlider.minimumValue = 0
        crownImpulseYSlider.maximumValue = 300
        crownImpulseYSlider.value = 50
        crownImpulseYSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        crownImpulseYSlider.minimumTrackTintColor = UIColor.blue

        self.view!.addSubview(crownImpulseYSlider)
    }
    
    
    func impulseApplication() {
        let impulseVectorX = Int(-crownImpulseXSlider.value)
        let impulseVectorY = Int(crownImpulseYSlider.value)
        let impulseVector = CGVector(dx: impulseVectorX, dy: impulseVectorY)
        crown.physicsBody?.applyImpulse(impulseVector)
        crown.physicsBody?.affectedByGravity = true
    }


}




