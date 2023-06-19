//
//  King.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import Foundation

import SpriteKit

class King: SKSpriteNode {
    static let defaultTexture = SKTexture(imageNamed: "not_king")
    static let kingTexture = SKTexture(imageNamed: "king")
    
    var isChanged = false
    
    init() {
        super.init(texture: King.defaultTexture, color: .clear, size: King.defaultTexture.size())
        name = "king"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTexture() {
        texture = King.kingTexture
        isChanged = true
    }
    
    func restoreTexture() {
        texture = King.defaultTexture
        isChanged = false
    }
}

