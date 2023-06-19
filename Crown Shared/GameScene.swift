//
//  GameScene.swift
//  Crown Shared
//
//  Created by Vladislav Andrushok on 16.06.2023.
//

import SpriteKit

class GameScene: SKScene {
    var kings: [King] = []
    var kingsToChange: [King] = []
    var predictedKingCounter = 0
    var isInteractionEnabled = true
    
    let lineSpacing: CGFloat = 120
    let lineHeight: CGFloat = 5
    let kingSpacing: CGFloat = 55
    let scaleFactor: CGFloat = 0.08
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .green
        createVerticalLines()
        startRandomTextureTimer()
    }
    
    func startRandomTextureTimer() {
        let timerInterval = 1.0
        let waitAction = SKAction.wait(forDuration: timerInterval)
        let changeTextureAction = SKAction.run { [weak self] in
            self?.changeRandomKingTextures()
        }
        let sequenceAction = SKAction.sequence([waitAction, changeTextureAction])
        run(sequenceAction)
        
        let restoreTimerInterval = 2.0
        let restoreAction = SKAction.wait(forDuration: restoreTimerInterval)
        let restoreTextureAction = SKAction.run { [weak self] in
            self?.restoreKingTextures()
            self?.exchangeKingPositions()
        }
        let restoreSequenceAction = SKAction.sequence([restoreAction, restoreTextureAction])
        run(restoreSequenceAction)
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isInteractionEnabled, let touch = touches.first else { return }
            
            let touchLocation = touch.location(in: self)
            
            let tappedKing = kings.first(where: { $0.contains(touchLocation) })
            
            if let king = tappedKing, kingsToChange.contains(king) {
                king.changeTexture()
                predictedKingCounter += 1
                print(predictedKingCounter)
                
                if predictedKingCounter == 3 {
                    arrangeKingsInCenter()
                }
            }
        }
    
    
    
}




