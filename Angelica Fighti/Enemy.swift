//
//  Enemy.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/31/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit


class Enemy{
    
    enum EnemyType{
        case Boss
        case Regular
        case Special
        
    }
    
    private var enemyModel:SKSpriteNode
    private var originX:CGFloat
    private var originY:CGFloat
    private var width:CGFloat
    private var height:CGFloat
    private var enemyType:EnemyType
    private var actionsStandBy:[SKTexture] = []
    private var actionsDead:[SKTexture] = []
    private var spriteName:String
    private var name = ""
    private var size:CGSize
    private var maxhp:CGFloat
    private var currency:Currency?
    private var isAlive:Bool = true
    
    
    var delegate:GameInfoDelegate?
    
    
    init (type: EnemyType){
        enemyModel = SKSpriteNode()
        enemyType = type
        
        switch(enemyType){
        case .Regular:
            spriteName = "enemyOne.png"
            name = "enemyOne"
            originX = screenSize.width/10
            originY = screenSize.height
            width = screenSize.width * 0.1691
            height = screenSize.height * 0.09511
            size = CGSize(width: width, height: height)
            maxhp = 100.0
            
        case .Boss:
            spriteName = "\(BOSS_SPRITES_DIR)/Boss_1/main.png"
            name = "Enemy_Boss"
            originX = screenSize.width/2
            originY = screenSize.height * ( 1 - 1/8)
            width = 180
            height = 130
            size = CGSize(width: width, height: height)
            maxhp = 1000.0
            currency  = Currency(type: .Coin)
            
            
        default:
            spriteName = "invalid.png"
            originX = 55
            originY = 750
            width = screenSize.width * 0.1691
            height = screenSize.height * 0.09511
            size = CGSize(width: width, height: height)
            maxhp = 100.0
            currency  = Currency(type: .Coin)
            print ("THIS SHOULD NOT BE RUN___ ")
        }
        
    }
    
    func load() -> Bool{
        enemyModel = SKSpriteNode(imageNamed: spriteName)
        enemyModel.texture = SKTexture(imageNamed: spriteName)
        enemyModel.userData = NSMutableDictionary()
        
        enemyModel.hp = self.maxhp
        enemyModel.maxHp = self.maxhp
        enemyModel.name = name
        enemyModel.position = CGPoint(x: originX, y: originY)
        enemyModel.size = size
        enemyModel.physicsBody =  SKPhysicsBody(texture: (enemyModel.texture!), size: (enemyModel.size))
        enemyModel.physicsBody!.isDynamic = false // allow physic simulation to move it
        enemyModel.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        enemyModel.physicsBody!.collisionBitMask = 0
        
        /*let enemyHealthBar = SKSpriteNode()
         enemyHealthBar.anchorPoint.x = 0
         enemyHealthBar.name = "hpBar"
         enemyHealthBar.size = CGSize(width: 60, height: 20)
         enemyHealthBar.position.x = -(enemyHealthBar.size.width/2)
         enemyHealthBar.position.y -= 50
         enemyHealthBar.color = .green*/
        
        
        let r = CGRect(x: 0, y: -4, width: 60, height: 10)
        let healthBorder = SKShapeNode(rect: r, cornerRadius: 5)
        healthBorder.glowWidth = 1.5
        healthBorder.strokeColor = .black
        healthBorder.name = "hpBorder"
        healthBorder.lineWidth = 1.5
        
        let enemyHealthBar = SKSpriteNode()
        enemyHealthBar.anchorPoint.x = 0
        enemyHealthBar.name = "hpBar"
        enemyHealthBar.size = CGSize(width: 60, height: 10)
        enemyHealthBar.position.x = -(enemyHealthBar.size.width/2)
        enemyHealthBar.position.y -= 50
        enemyHealthBar.color = .green
        enemyHealthBar.zPosition = -0.1
        
        enemyHealthBar.addChild(healthBorder)
        
        
        switch enemyType {
        case .Regular:
            currency  = Currency(type: .Coin, avaudio: delegate?.mainAudio)
            /*for i in 1...18{
                actionsDead += [SKTexture(imageNamed: "\(ENEMY_SPRITES_DIR)/Die/action\(i)")]
            }*/
            let deadTexturesAtlas312 = SKTextureAtlas(named: "test.atlas/subfolder")
            let deadTexturesAtlas = SKTextureAtlas(named: "/\(ENEMY_SPRITES_DIR)/Die.atlas")
           // let numTextures = deadTexturesAtlas.textureNames.count
           
            
            for texture in deadTexturesAtlas312.textureNames{
                //actionsDead.append(deadTexturesAtlas.textureNamed(texture))
                print(texture)
            }
            
            
            for texture in deadTexturesAtlas.textureNames{
                //actionsDead.append(deadTexturesAtlas.textureNamed(texture))
                print(texture)
            }
            
        case .Boss:
            enemyHealthBar.position.y -= 30
            actionsStandBy = [SKTexture(imageNamed: "\(BOSS_SPRITES_DIR)/Boss_1/action1"), SKTexture(imageNamed: "\(BOSS_SPRITES_DIR)/Boss_1/action2"), SKTexture(imageNamed: "\(BOSS_SPRITES_DIR)/Boss_1/action3"), SKTexture(imageNamed: "\(BOSS_SPRITES_DIR)/Boss_1/action2")]
            for i in 4...21{
                actionsDead += [SKTexture(imageNamed: "\(BOSS_SPRITES_DIR)/Boss_1/action\(i)")]
            }
        default:
            print ("THIS SHOULD NOT BE RUN__")
            return false
        }
        
        enemyHealthBar.isHidden = true
        
        enemyModel.addChild(enemyHealthBar)
        
        return true
    }
    
    func spawnEnemy(){
        
        switch enemyType {
        case .Boss:
            guard let enemy = enemyModel.copy() as? SKSpriteNode else{
                print ("ERROR :: There was an error spawning boss. Check Classes.swift // Class Enemy // Method spawnEnemy()")
                return
            }
            // Set up enemy HP
            enemy.hp = enemy.maxHp
            // Make it immune for a moment
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.None
            // Set up Animation of Boss
            enemy.run(SKAction.repeatForever(SKAction.animate(with: actionsStandBy, timePerFrame: 0.77)))
            // Set initial alpha
            enemy.alpha = 0
            // creating an immune box for the boss
            let imuneBox = SKSpriteNode()
            imuneBox.size = enemy.size
            imuneBox.name = "imuneBox"
            imuneBox.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            imuneBox.physicsBody!.categoryBitMask = PhysicsCategory.Imune
            imuneBox.physicsBody?.isDynamic = false
            enemy.addChild(imuneBox)
            
            // Run animation ( set alpha to 1 ) then remove immune shield
            enemy.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 2.5), SKAction.run {
                enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                imuneBox.removeFromParent()
                }]))
            
            delegate?.addChild(sknode: enemy)
        case .Regular:
            for i in stride(from: originX + 10, to: screenSize.width, by: originX + enemyModel.size.width/2){
                
                guard let enemy = enemyModel.copy() as? SKSpriteNode else{
                    print ("ERROR :: There was an error creating enemy. Check Classes.swift // Class Enemy // Method spawnEnemy()")
                    return
                }
                enemy.position = CGPoint(x: i, y: originY)
                enemy.hp = enemy.maxHp
                //   enemy.sound = delegate?.mainAudio.createAudio(type: .Coin, volume: 1.0)
                enemy.run(SKAction.sequence([SKAction.moveTo(y: -100, duration: 3), SKAction.removeFromParent()]))
                
                // TESTING ADDING MUSIC
                enemy.addChild((delegate?.mainAudio.createAudio(type: .Puff))!)
                delegate?.addChild(sknode: enemy)
            }
        case .Special:
            break
        }
    }
    
    func getNode() -> SKSpriteNode{
        return enemyModel
    }
    
    
    
    func update(sknode: SKSpriteNode){
    
        if let enemyHP = sknode.childNode(withName: "hpBar"){
            
            let percentage = sknode.hp/sknode.maxHp
            
            if (percentage < 0.3){
                enemyHP.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.1))
            }
                
            else if (percentage < 0.55){
                 enemyHP.run(SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0.1))            }
        }
        
    }
    
    
    func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode){
        
        ofTarget.hp = ofTarget.hp - hitBy.power
        
        guard let enemyHpBar = ofTarget.childNode(withName: "hpBar") else{
            return
        }
        
        if (hitBy.name == "bullet"){
            
            
            let percentage = ofTarget.hp > 0.0 ? ofTarget.hp/ofTarget.maxHp : 0.0
            
            enemyHpBar.run(SKAction.resize(toWidth: 60 * percentage, duration: 0.03))
        }
        
        update(sknode: ofTarget)
        
        if (ofTarget.hp > -5000 && ofTarget.hp <= 0){
            ofTarget.hp = -9999
            
            ofTarget.childNode(withName: "hpBar")?.removeFromParent()
            explode(sknode: ofTarget)
            return
        }
        else{
            if enemyHpBar.isHidden {
            enemyHpBar.isHidden = false
            }
            
            
        }
    }
    
    func getStatus() -> Bool{
        return isAlive
    }
    
    // enemy die & explosion of gold
    func explode(sknode: SKSpriteNode){
        
        
        let rewardCount:Int = randomInt(min: 1, max: 4)
        
        //print (rewardCount)
        
        for _ in 0..<rewardCount{
            let reward = currency?.createCoin(posX: sknode.position.x, posY: sknode.position.y, createPhysicalBody: true, animation: true)
           
           
            let impulse = CGVector(dx: random(min: -25, max: 25), dy: random(min:10, max:35))
            
            reward?.run(SKAction.sequence([SKAction.applyForce(impulse , duration: 0.2), SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
            
            if let r = reward{
                delegate?.addChild(sknode: r)
            }
            else{
                
                print("ERROR ON CLASS ENEMY. Check Method Explosion. ")
            }
        }
        
        sknode.removeAllActions()
        
        switch (enemyType){
        case .Boss:
            // print ("DISPLAY ANIMATION")
            sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
            sknode.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.11),SKAction.run {
                sknode.removeFromParent()
                // update gameinfo state
                self.delegate?.updateGameState(state: .NoState)
                }]))
        case .Regular:
            sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
            sknode.position.y -= 50
            sknode.run(SKAction.scale(by: 2, duration: 0.1))
            
           sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
           
            sknode.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.02),SKAction.run {
                sknode.removeFromParent()
                }]))
            
        default:
            //  print ("REGULAR DEATH")
            sknode.removeFromParent()
            
            
        }
        
        
        
    }
    
    func getCurrency() -> Currency{
        return currency!
    }
    
}
