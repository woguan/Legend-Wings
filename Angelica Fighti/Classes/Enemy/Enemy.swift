//
//  Enemy.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 7/11/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode{
    
    var hp:CGFloat = 0
    var maxHp:CGFloat = 0
    
    convenience init(hp: CGFloat){
        self.init()
        self.hp = hp
        self.maxHp = hp
    }
    
    
    func addHealthBar(){
        let w:CGFloat = size.width * 0.9
        let h:CGFloat = 10.0
        
        let shape = CGRect(x: 0, y: -5, width: w, height: h)
        let border = SKShapeNode(rect: shape, cornerRadius: 5)
        border.glowWidth = 1.5
        border.strokeColor = .black
        border.name = "hpBorder"
        border.lineWidth = 1.5
        
        let bar = SKSpriteNode()
        bar.anchorPoint.x = -0.01
        bar.name = "hpBar"
        bar.size = CGSize(width: w*0.98, height: h*0.8)
        bar.color = .green
        bar.zPosition = -0.1
        bar.position.x = -(bar.size.width/2)
        bar.position.y = -size.height/2 - 10
        bar.isHidden = true
        bar.addChild(border)
        
        let rootBar = SKSpriteNode()
        rootBar.size = bar.size//abs(border.frame.minX) + abs(border.frame.maxX)
        rootBar.color = .clear
        rootBar.name = "rootBar"
        rootBar.addChild(bar)
        
        self.addChild(rootBar)
    }
    
    
}
