//
//  GameScene+Touches.swift
//  Crown iOS
//
//  Created by Vladislav Andrushok on 20.06.2023.
//

import Foundation
import SpriteKit

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        if crown.contains(touchLocation) {
            impulseApplication()
        } else {
            guard isInteractionEnabled else { return }
            
            let tappedKing = crowdOfPeople.first(where: { $0.contains(touchLocation) && !tappedKings.contains($0) })
            
            if let king = tappedKing, princeArr.contains(king) {
                tappedKings.insert(king)
                king.changeTexture()
                predictedKingCounter += 1
                
                if predictedKingCounter == 3 {
                    arrangePrinceInCenter()
                }
            }
        }
    }

    
    
    
}
