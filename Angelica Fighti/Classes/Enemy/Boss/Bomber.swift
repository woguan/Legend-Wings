//
//  Bomber.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/26/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class Bomber:Enemy{
    
    private var actionsStandBy:[SKTexture] = []
    private var actionsDead:[SKTexture] = []
    private var currency:Currency = Currency(type: .Coin)
    
    convenience init(hp:CGFloat){
        self.init()
        
        name = "Enemy_Boss"
        texture = global.getMainTexture(main: .Boss_1)
        size = CGSize(width: 180, height: 130)
        position.x = screenSize.width/2
        position.y = screenSize.height * (1 - 1/8)
        alpha = 0
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        currency  = Currency(type: .Coin)
        
        actionsStandBy = global.getTextures(textures: .Boss_1_Move_Animation)
        actionsDead = global.getTextures(textures: .Boss_1_Dead_Animation)
        
        initialSetup()
    }
    
    private func initialSetup(){
        // adding healthbar
        self.addHealthBar()
        
        // Set up Animation of Boss
        self.run(SKAction.repeatForever(SKAction.animate(with: actionsStandBy, timePerFrame: 0.77)))
        // Set initial alpha
        self.physicsBody = SKPhysicsBody(texture: global.getMainTexture(main: .Boss_1), size: self.size)
        self.physicsBody!.isDynamic = true // allow physic simulation to move it
        self.physicsBody!.categoryBitMask = PhysicsCategory.Imune // None at beginning
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.fieldBitMask = GravityCategory.None
        self.physicsBody!.collisionBitMask = 0
        
        // Set up Animation of Boss
        self.run(SKAction.repeatForever(SKAction.animate(with: actionsStandBy, timePerFrame: 0.77)))
        
        self.run(SKAction.sequence([SKAction.fadeIn(withDuration: 2.5), SKAction.run {
                self.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                self.startAttack()
            }]))
        
    }
    
    private func startAttack(){
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
            let random = randomInt(min: 0, max: 100)
            if (random > 80){
                let att = SKSpriteNode(texture: global.getAttackTexture(attack: .Boss1_type_1))
                att.size = CGSize(width: 30, height: 30)
                att.name = "Enemy_Boss_1_Attack"
                att.physicsBody = SKPhysicsBody(circleOfRadius: 15)
                att.physicsBody!.isDynamic = true
                att.physicsBody!.affectedByGravity = true
                att.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                att.physicsBody!.contactTestBitMask = PhysicsCategory.Player
                att.physicsBody!.fieldBitMask = GravityCategory.None
                att.physicsBody!.collisionBitMask = 0
                
                att.run(SKAction.sequence([SKAction.wait(forDuration: 3.5), SKAction.removeFromParent()]))
                self.addChild(att)
                
                let force = CGVector(dx: randomInt(min: -100, max: 100), dy: 0)
                att.run(SKAction.applyForce(force, duration: 0.1))
            }
            
            }])))
    }
    
    internal func defeated(){
        self.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.11),SKAction.run {
            self.removeFromParent()
            }]))
    }
    
}

//name = "Enemy_Boss"
//originX = screenSize.width/2
//originY = screenSize.height * (1 - 1/8)
//width = 180
//height = 130
//position = CGPoint(x: originX, y: originY)
//size = CGSize(width: width, height: height)
//maxhp = 1000.0
//velocity = CGVector(dx: 0, dy: 0)
//currency  = Currency(type: .Coin)
//
//actionsStandBy = global.getTextures(textures: .Boss_1_Move_Animation)
//actionsDead = global.getTextures(textures: .Boss_1_Dead_Animation)
