//
//  GameScene+ContactDelegate.swift
//  Crown
//
//  Created by Vladislav Andrushok on 23.06.2023.
//

import Foundation
import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.hasContact(contact: contact, categoryA: BitMasks.centerFixationCrownNode, categoryB: BitMasks.nodeFixationCrown) != nil {
            isContactOngoing = true
            contactTimer?.invalidate()
            contactTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(handleContactTimer), userInfo: nil, repeats: false)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.hasContact(contact: contact, categoryA: BitMasks.centerFixationCrownNode, categoryB: BitMasks.nodeFixationCrown) != nil {
            isContactOngoing = false
            contactTimer?.invalidate()
        }
    }
    
    @objc func handleContactTimer() {
        if isContactOngoing {
            let confetti = SKEmitterNode(fileNamed: "Confetti")!
            confetti.position = CGPoint(x: frame.midX, y: frame.maxY)
            confetti.zPosition = 5
            addChild(confetti)
            
        }
    }
}


extension SKPhysicsContact {
    func hasContact(contact: SKPhysicsContact, categoryA: UInt32, categoryB: UInt32) -> (bodyA: SKPhysicsBody, bodyB: SKPhysicsBody)? {
            let bodyA: SKPhysicsBody = bodyA
            let bodyB: SKPhysicsBody = bodyB
            if (bodyA.categoryBitMask == categoryA && bodyB.categoryBitMask == categoryB) {
                return (bodyA, bodyB)
            }
            if (bodyA.categoryBitMask == categoryB && bodyB.categoryBitMask == categoryA) {
                return (bodyB, bodyA)
            }
            return nil
        }
}
