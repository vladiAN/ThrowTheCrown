//
//  GameScene+ImpulsSlider.swift
//  Crown iOS
//
//  Created by Vladislav Andrushok on 22.06.2023.
//

import Foundation

extension GameScene {
    
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
    
    func addCrownRotationSlider() {
        let sliderXPosition = frame.midX * 1.6
        let sliderYPosition = frame.minY + crownRotationSlider.frame.height * 2.7
        
        crownRotationSlider.slidingHandler = { data in
            let maxRotationAngle: CGFloat = .pi
            self.rotationAngleForCrown = data * maxRotationAngle
            
            self.crown.zRotation = self.rotationAngleForCrown
        }
        
        crownRotationSlider.position = CGPoint(x: sliderXPosition, y: sliderYPosition)
        addChild(crownRotationSlider)
        
        crownRotationSlider.scrollCenter.position.x = 0
    }
    
    
    
}
