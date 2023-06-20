//
//  People.swift
//  Crown
//
//  Created by Vladislav Andrushok on 19.06.2023.
//

import Foundation

import SpriteKit

class People: SKSpriteNode {
    static let defaultTexture = SKTexture(imageNamed: "not_king")
    static let princeTexture = SKTexture(imageNamed: "king")
    
    var isChanged = false
    
    init() {
        super.init(texture: People.defaultTexture, color: .clear, size: People.defaultTexture.size())
        name = "king"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeTexture() {
        texture = People.princeTexture
        isChanged = true
    }
    
    func restoreTexture() {
        texture = People.defaultTexture
        isChanged = false
    }
}

