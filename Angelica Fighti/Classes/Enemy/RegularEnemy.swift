//
//  RegularEnemy.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/27/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class RegularEnemy:SKSpriteNode{
    
    
    private var currency:Currency = Currency(type: .Coin)
    private var velocity = CGVector(dx: 0, dy: -400)
    
    private var actionsDead:[SKTexture] = []
    private var enemy_regular_node:SKSpriteNode?
    
    private var remaining = 5
    
    private let minionSize = CGSize(width: screenSize.width*0.95/5, height: screenSize.width*0.95/5)
    
    convenience init(baseHp:CGFloat){
        self.init()

        name = "Enemy_Regular_Box"
        position = CGPoint(x: screenSize.width/2, y: screenSize.height + 200)
        size = CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
       
        userData = NSMutableDictionary()
        self.hp = baseHp
        self.maxHp = baseHp
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
        velocity = CGVector(dx: 0, dy: -350)
        currency  = Currency(type: .Coin)
        
        actionsDead = global.getTextures(textures: .Puff_Animation)
        enemy_regular_node = SKSpriteNode()
        enemy_regular_node!.size = self.size
        enemy_regular_node!.texture = global.getMainTexture(main: .Enemy_1)
        
        initialSetup()
        setMinions()
    }
    
    private func initialSetup(){
        
        guard let enemy_regular_node = enemy_regular_node else{
            return
        }
    
        enemy_regular_node.userData = NSMutableDictionary()
        enemy_regular_node.hp = self.maxHp
        enemy_regular_node.maxHp = self.maxHp
        enemy_regular_node.name = "Enemy_Regular"
        enemy_regular_node.size = minionSize
        enemy_regular_node.physicsBody = SKPhysicsBody(rectangleOf: enemy_regular_node.size)
        enemy_regular_node.physicsBody!.isDynamic = true
        enemy_regular_node.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        enemy_regular_node.physicsBody!.affectedByGravity = false
        enemy_regular_node.physicsBody!.collisionBitMask = 0
        enemy_regular_node.physicsBody!.velocity = self.velocity
        enemy_regular_node.addHealthBar()
        
        for i in 0..<3{
            
            if i == 0 {
                let node = enemy_regular_node.copy() as! SKSpriteNode
                self.addChild(node)
                continue
            }
            else{
                let lnode = enemy_regular_node.copy() as! SKSpriteNode
                lnode.position.x = CGFloat(-i)*minionSize.width
                let rnode = enemy_regular_node.copy() as! SKSpriteNode
                rnode.position.x = CGFloat(i)*minionSize.width
                self.addChild(lnode)
                self.addChild(rnode)
            }
        }
    }
    
    
    private func setMinions(){
        
        func modifyHP(sknode: SKSpriteNode, multiplier: CGFloat, newTexture: SKTexture){
            sknode.hp = self.maxHp * multiplier
            sknode.maxHp = self.maxHp * multiplier
            sknode.texture = newTexture
        }
        
        for enemy in self.children {
            
            let x = randomInt(min: 1, max: 7)
            let enemySK = enemy as! SKSpriteNode
            if x == 1{
                modifyHP(sknode: enemySK, multiplier: 1.0, newTexture: global.getMainTexture(main: .Enemy_1))
            }
            else if x == 2 {
                modifyHP(sknode: enemySK, multiplier: 1.05, newTexture: global.getMainTexture(main: .Enemy_2))
            }
            else if x == 3 {
                modifyHP(sknode: enemySK, multiplier: 1.1, newTexture: global.getMainTexture(main: .Enemy_3))
            }
            else if x == 4 {
                modifyHP(sknode: enemySK, multiplier: 1.12, newTexture: global.getMainTexture(main: .Enemy_4))
            }
            else if x == 5 {
                modifyHP(sknode: enemySK, multiplier: 1.13, newTexture: global.getMainTexture(main: .Enemy_5))
            }
            else if x == 6 {
                modifyHP(sknode: enemySK, multiplier: 1.14, newTexture: global.getMainTexture(main: .Enemy_6))
            }
            else{
                modifyHP(sknode: enemySK, multiplier: 1.15, newTexture: global.getMainTexture(main: .Enemy_7))
            }
        }
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
    }
    
    internal func raiseBaseHp(byValue val: CGFloat){
        self.maxHp = maxHp + val
    }
    
    internal func raiseVelocity(byValue val: CGFloat){
        velocity.dy -= val
    }
    
    internal func defeated(sknode:SKSpriteNode){
        sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
        sknode.position.y -= 50
        sknode.run(SKAction.scale(by: 2, duration: 0.1))
        sknode.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.02),SKAction.run {
            sknode.removeFromParent()
            }]))
    }
}
