//
//  RegularEnemy.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/27/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class RegularEnemy:Enemy{
    
    
    private var currency:Currency = Currency(type: .Coin)
    private var velocity = CGVector.zero
    
    private var actionsDead:[SKTexture] = []
    private var enemy_regular_node:Enemy?
    
    private var remaining = 5
    
    private let minionSize = CGSize(width: screenSize.width*0.95/5, height: screenSize.width*0.95/5)
    
    convenience init(baseHp:CGFloat, speed:CGVector){
        self.init()

        name = "Enemy_Regular_Box"
        position = CGPoint(x: screenSize.width/2, y: screenSize.height + 200)
        size = CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
       
        userData = NSMutableDictionary()
        self.hp = baseHp
        self.maxHp = baseHp
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        
        velocity = speed
        currency  = Currency(type: .Coin)
        
        actionsDead = global.getTextures(textures: .Puff_Animation)
        enemy_regular_node = Enemy()
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
        enemy_regular_node.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
        enemy_regular_node.addHealthBar()
        
        for i in 0..<3{
            
            if i == 0 {
                let node = enemy_regular_node.copy() as! Enemy
                self.addChild(node)
                continue
            }
            else{
                let lnode = enemy_regular_node.copy() as! Enemy
                lnode.position.x = CGFloat(-i)*minionSize.width
                let rnode = enemy_regular_node.copy() as! Enemy
                rnode.position.x = CGFloat(i)*minionSize.width
                self.addChild(lnode)
                self.addChild(rnode)
            }
        }
    }
    
    
    private func setMinions(){
        
        func modifyHP(sknode: Enemy, multiplier: CGFloat){
            sknode.hp = self.maxHp * multiplier
            sknode.maxHp = self.maxHp * multiplier
        }
        
        for enemy in self.children {
            
            let x = randomInt(min: 1, max: 100)
            let enemySK = enemy as! Enemy
            
            if x < 5{
                enemySK.size = CGSize(width: screenSize.width * 0.169, height: screenSize.height * 0.1005)
                enemy.run(SKAction.repeatForever(SKAction.animate(with: global.getTextures(textures: .Regular_Bluer_Sprites), timePerFrame: 0.07)))
                modifyHP(sknode: enemySK, multiplier: 2.0)
            }
            else if x >= 5 && x < 20 {
                enemySK.size = CGSize(width: screenSize.width * 0.208, height: screenSize.height * 0.115)
                enemySK.run(SKAction.repeatForever(SKAction.animate(with: global.getTextures(textures: .Regular_Grenner_Sprites), timePerFrame: 0.07)))
                modifyHP(sknode: enemySK, multiplier: 1.5)
            }
            else if x >= 20 && x < 40 {
                enemySK.size = CGSize(width: screenSize.width * 0.164, height: screenSize.height * 0.1)
                enemySK.run(SKAction.repeatForever(SKAction.animate(with: global.getTextures(textures: .Regular_Purpler_Sprites), timePerFrame: 0.07)))
                modifyHP(sknode: enemySK, multiplier: 1.3)
            }
            else {
                enemySK.size = CGSize(width: screenSize.width * 0.1667, height: screenSize.height * 0.096)
                enemySK.run(SKAction.repeatForever(SKAction.animate(with: global.getTextures(textures: .Regular_Redder_Sprites), timePerFrame: 0.07)))
            }
            
        }
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
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
