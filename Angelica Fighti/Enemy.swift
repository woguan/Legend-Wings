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

class EnemyModel: NSObject{
    
    deinit{
    print("NewEnemy Deinitiated")
    }
    enum EnemyType{
        case Boss
        case Regular
        case Fireball
        case Special
        
    }
    
    // For Regular Enemies
    private var enemy_box_array:[SKSpriteNode] = []
    
    // Shared Variables
    private var originX:CGFloat
    private var originY:CGFloat
    private var position:CGPoint
    private var width:CGFloat
    private var height:CGFloat
    private var enemyType:EnemyType
    private var actionsStandBy:[SKTexture] = []
    private var actionsDead:[SKTexture] = []
    private var hasSetUp:Bool
    
    
    private var enemyModel:SKSpriteNode?
    private var enemy_regular_node:SKSpriteNode?
    private var name = ""
    private var size:CGSize
    private var maxhp:CGFloat
    private var currency:Currency?
    private var isAlive:Bool = true
    
    private var velocity:CGVector
    
    var delegate:GameInfoDelegate?
    
    var tempHP:Int
    var tempMAXHP: Int
    
    init(type: EnemyType){
        hasSetUp = false
        
        tempHP = 100
        tempMAXHP = 100
        
        enemyType = type
        
        enemyModel = SKSpriteNode()
        
        switch(enemyType){
        case .Regular:
            name = "Enemy_Regular_Box"
            
            position = CGPoint(x: screenSize.width/2, y: screenSize.height + 200)
            size = CGSize(width: screenSize.width, height: screenSize.width*0.95/5)
            originX = position.x
            originY = position.y
            width = size.width
            height = size.height
            velocity = CGVector(dx: 0, dy: -350)
            maxhp = 100.0
            
            currency  = Currency(type: .Coin, avaudio: delegate?.mainAudio)
            actionsDead = global.getTextures(textures: .Puff_Animation)
            
            enemy_regular_node = SKSpriteNode()
            enemy_regular_node!.size = self.size
            enemy_regular_node!.texture = global.getMainTexture(main: .Enemy_1)
            
        case .Boss:
            name = "Enemy_Boss"
            originX = screenSize.width/2
            originY = screenSize.height * ( 1 - 1/8)
            width = 180
            height = 130
            position = CGPoint(x: originX, y: originY)
            size = CGSize(width: width, height: height)
            maxhp = 1000.0
            velocity = CGVector(dx: 0, dy: 0)
            currency  = Currency(type: .Coin)
            
            actionsStandBy = global.getTextures(textures: .Boss_1_Move_Animation)
            actionsDead = global.getTextures(textures: .Boss_1_Dead_Animation)
        
        case .Fireball:
            name = "Enemy_Fireball"
            originX = 0
            originY = 0
            width = screenSize.size.width/5
            height = screenSize.height/4.74
            position = CGPoint.zero
            size = CGSize(width: width, height: height)
            maxhp = 10.0
            velocity = CGVector(dx: 0, dy: -400)
            currency  = Currency(type: .None)
        default:
            originX = 55
            originY = 750
            width = screenSize.width * 0.1691
            height = screenSize.height * 0.09511
            size = CGSize(width: width, height: height)
            position = CGPoint(x: originX, y: originY)
            maxhp = 100.0
            currency  = Currency(type: .Coin)
            velocity = CGVector(dx: 0, dy: 0)
            print ("THIS SHOULD NOT BE RUN___ ")
        }
        
    }
    
     func setUP(){
        
        func createHealthBar(width w: CGFloat, height h: CGFloat) -> SKSpriteNode{
            
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
                bar.position.y = -enemyModel!.size.height/2 - 10
            
                bar.addChild(border)
            
                bar.isHidden = true
            
            return bar
        }
        
       
        
        guard let enemyModel = enemyModel else{
            print("Warning: enemyModel is nil.")
            return
        }
        
        enemyModel.size = self.size
        enemyModel.position = self.position
        
        
        if self.enemyType == .Boss {
            let enemyHealthBar = createHealthBar(width: enemyModel.size.width * 0.9, height: 10)
            enemyModel.userData = NSMutableDictionary()
            enemyModel.hp = self.maxhp
            enemyModel.maxHp = self.maxhp
            enemyModel.name = name
            enemyModel.texture = global.getMainTexture(main: .Boss_1)
            
            enemyModel.physicsBody = SKPhysicsBody(texture: enemyModel.texture!, size: enemyModel.size)
            enemyModel.physicsBody!.isDynamic = true // allow physic simulation to move it
            enemyModel.physicsBody!.categoryBitMask = PhysicsCategory.None // None at beginning
            enemyModel.physicsBody!.affectedByGravity = false
            enemyModel.physicsBody!.collisionBitMask = 0
            enemyModel.physicsBody!.velocity = self.velocity
            enemyModel.addChild(enemyHealthBar)
            
            
            // Set up Animation of Boss
            enemyModel.run(SKAction.repeatForever(SKAction.animate(with: actionsStandBy, timePerFrame: 0.77)))
            // Set initial alpha
            enemyModel.alpha = 0
            // creating an immune box for the boss
            let imuneBox = SKSpriteNode()
            imuneBox.size = enemyModel.size
            imuneBox.name = "imuneBox"
            imuneBox.physicsBody = SKPhysicsBody(rectangleOf: enemyModel.size)
            imuneBox.physicsBody!.categoryBitMask = PhysicsCategory.Imune
            imuneBox.physicsBody!.isDynamic = false
            enemyModel.addChild(imuneBox)
            
            
        }
        
        else if self.enemyType == .Regular{
            
            guard let enemy_regular_node = enemy_regular_node else{
                return
            }
            let tsize = CGSize(width: enemyModel.size.height, height: enemyModel.size.height)
            
            let enemyHealthBar = createHealthBar(width: tsize.width * 0.9, height: 10)
            
            enemy_regular_node.userData = NSMutableDictionary()
            enemy_regular_node.hp = self.maxhp
            enemy_regular_node.maxHp = self.maxhp
            enemy_regular_node.name = "Enemy_Regular"
            enemy_regular_node.size = tsize
            enemy_regular_node.physicsBody = SKPhysicsBody(rectangleOf: enemy_regular_node.size)
            enemy_regular_node.physicsBody!.isDynamic = true
            enemy_regular_node.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            enemy_regular_node.physicsBody!.affectedByGravity = false
            enemy_regular_node.physicsBody!.collisionBitMask = 0
            enemy_regular_node.physicsBody!.velocity = self.velocity
           
            enemy_regular_node.addChild(enemyHealthBar)
            
            
            for i in 0..<3{
                    if i == 0 {
                        let node = enemy_regular_node.copy() as! SKSpriteNode
                        enemyModel.addChild(node)
                        continue
                    }
                else{
                        let lnode = enemy_regular_node.copy() as! SKSpriteNode
                        lnode.position.x = CGFloat(-i)*tsize.width
                        let rnode = enemy_regular_node.copy() as! SKSpriteNode
                        rnode.position.x = CGFloat(i)*tsize.width
                        enemyModel.addChild(lnode)
                        enemyModel.addChild(rnode)
                            }
                        }
        }
        
        else if enemyType == .Fireball{
            let auratextures = global.getTextures(textures: .Fireball_Aura)
            let facetextures = global.getTextures(textures: .Fireball_Face)
            let smoketextures = global.getTextures(textures: .Fireball_Smoke)
            let trackerTexture = global.getMainTexture(main: .Fireball_Tracker)
            
            func getAura() -> SKSpriteNode{
                
                let animation = SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: auratextures, timePerFrame: 0.08)]))
                let fadeinfadeout = SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0.8, duration: 0.07), SKAction.fadeAlpha(to: 1.0, duration: 0.01)]))
                let groupAction = SKAction.group([animation, fadeinfadeout])
                
                let sknode = SKSpriteNode()
                    sknode.size = CGSize(width: screenSize.width/5, height: screenSize.height/4.74)
                    sknode.run(groupAction)
                
                return sknode
            }
            
            func getFace() -> SKSpriteNode{
                
                let animation = SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: facetextures, timePerFrame: 0.05)]))
                let sknode = SKSpriteNode()
                sknode.size = CGSize(width: screenSize.width/5 * 0.9, height: 110)
                sknode.anchorPoint = CGPoint(x: 0.5, y: 0)
                sknode.position.y = -screenSize.height/4.74/2
                sknode.run(animation)
                return sknode
            }
            
            // Enemymodel
                enemyModel.size = CGSize(width: screenSize.width/5, height: screenSize.width/5)
                enemyModel.position.y = screenSize.height - enemyModel.size.height
                enemyModel.color = .clear
            
            
            // First is the tracker
            let scaleNormal = SKAction.scale(to: 1.0, duration: 0.1)
            let scaleBig = SKAction.scale(to: 1.1, duration: 0.1)
            let scaleLarge = SKAction.scale(to: 1.6, duration: 0.1)
            let scaleAction = SKAction.sequence([scaleLarge, scaleNormal, scaleBig, scaleNormal])
            
            let fadeout = SKAction.fadeIn(withDuration: 0.25)
            let fadein = SKAction.fadeOut(withDuration: 0.25)
            let sfadeout = SKAction.fadeIn(withDuration: 0.15)
            let sfadein = SKAction.fadeOut(withDuration: 0.15)
            let blink = SKAction.repeat(SKAction.sequence([fadeout, fadein]), count: 2)
            let sblink = SKAction.repeat(SKAction.sequence([sfadeout, sfadein]), count: 2)
            
            let track = SKSpriteNode()
                track.size = CGSize(width: 45, height: 54)
                track.anchorPoint = CGPoint(x: 0.5, y: 0)
                track.position.y = -enemyModel.size.height/2
                track.texture = trackerTexture
                track.run(SKAction.sequence([scaleAction, blink, sblink]))
                enemyModel.addChild(track)
            
            let hide = SKAction.hide()//SKAction.fadeOut(withDuration: 0)
            let show = SKAction.unhide() //SKAction.fadeIn(withDuration: 0.1)
            let scaleline = SKAction.scaleX(to: 5, duration: 1.5)
            let lineaction = SKAction.sequence([hide, SKAction.wait(forDuration: 0.3), show, scaleline])
            let line = SKSpriteNode()
            
                line.position.y = 3
                line.size = CGSize(width: 1, height: screenSize.size.height)
                line.anchorPoint = CGPoint(x: 0.5, y: 1)
                line.color = .yellow
                line.run(lineaction)
                track.addChild(line)
            
            
            // actual fireball
            let auranode = getAura()
                auranode.name = self.name  // the main node
                auranode.position.y = 200
                enemyModel.addChild(auranode)
            
            let facenode = getFace()
                facenode.zPosition = 1
                auranode.addChild(facenode)
    
            let emitnode = SKEmitterNode(fileNamed: "trail.sks")
                emitnode!.zPosition = -1
                auranode.addChild(emitnode!)
            
            
            
                auranode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenSize.width/8, height: screenSize.width/4), center: CGPoint(x: 0, y: -10))
                auranode.physicsBody!.isDynamic = true
                auranode.physicsBody!.affectedByGravity = false
                auranode.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                auranode.physicsBody!.contactTestBitMask = PhysicsCategory.Player
                auranode.physicsBody!.collisionBitMask = 0
                auranode.physicsBody!.velocity.dy = 0
        }
        
        hasSetUp = true
    }
    
    internal func increaseHP(){
        self.maxhp += 5
    }
    
    internal func increaseVelocityBy (amount:CGFloat){
        self.velocity.dy += (-amount)
    }
    
    internal func spawn(scene :SKScene){
        
        if !hasSetUp{
            print("Class Enemy.hasSetUp is false. Please, Initialize it.")
            return
        }
        let node = self.enemyModel!.copy() as! SKSpriteNode
        
        switch enemyType {
        case .Regular:
            
            func modifyHP(sknode: SKSpriteNode, multiplier: CGFloat, newTexture: SKTexture){
                sknode.hp = self.maxhp * multiplier
                sknode.maxHp = self.maxhp * multiplier
                sknode.texture = newTexture
            }
            
            for enemy in node.children {
                
                let x = randomInt(min: 1, max: 7)
                print("called: ", x)
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
            
            
            
            node.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        case .Boss:
            // Run animation ( set alpha to 1 ) then remove immune shield
            node.run(SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 2.5), SKAction.run {
                node.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                node.childNode(withName: "imuneBox")?.removeFromParent()
                }]))
            
            // adding attack
            node.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run {
                let random = randomInt(min: 0, max: 100)
                if (random > 50){
                    let att = SKSpriteNode(texture: global.getAttackTexture(attack: .Boss1_type_1))
                    att.size = CGSize(width: 30, height: 30)
                    att.name = "Enemy_Boss_1_Attack"
                    att.physicsBody = SKPhysicsBody(circleOfRadius: 15)
                    att.physicsBody!.isDynamic = true
                    att.physicsBody!.affectedByGravity = true
                    att.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
                    att.physicsBody!.contactTestBitMask = PhysicsCategory.Player
                    att.physicsBody!.collisionBitMask = 0
                    
                    att.run(SKAction.sequence([SKAction.wait(forDuration: 3.5), SKAction.removeFromParent()]))
                    node.addChild(att)
                    
                    let force = CGVector(dx: randomInt(min: -100, max: 100), dy: 0)
                    att.run(SKAction.applyForce(force, duration: 0.1))
                }
                
                }])))
        case .Fireball:
            
            node.position.x = self.originX
            
            guard let fireball = node.childNode(withName: "Enemy_Fireball") else{
                return
            }
            
            let setVelocity = SKAction.sequence([SKAction.run {
                fireball.physicsBody!.velocity.dy = -400
                }])
            
            let AIMove = SKAction.run {
                if let toon = scene.childNode(withName: "toon"){
                    
                    if node.position.x < toon.position.x{
                           node.position.x += 0.3
                        }
                    else if node.position.x > toon.position.x{
                            node.position.x -= 0.3
                    }
                }
            }
            let repeatAI = SKAction.repeat(SKAction.sequence([AIMove, SKAction.wait(forDuration: 0.01)]), count: 80)
            
            let AIAction = SKAction.sequence([SKAction.wait(forDuration: 0.2), AIMove, repeatAI, SKAction.wait(forDuration: 0.5)])
            
            node.run(SKAction.sequence([AIAction, setVelocity, SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
            
        default:
            node.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        }
        
        
        scene.addChild(node)
    }
    
    internal func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode){
        
        
        guard let enemyHpBar = ofTarget.childNode(withName: "hpBar") else{
            return
        }
            ofTarget.hp = ofTarget.hp - hitBy.power
        
        if (hitBy.name == "bullet"){
            
            let percentage = ofTarget.hp > 0.0 ? ofTarget.hp/ofTarget.maxHp : 0.0
            
            
            let bar = enemyHpBar.childNode(withName: "hpBorder")! as! SKShapeNode
            let originalBarSize = bar.frame.width * 0.98 // Note: barSize = 0.98 * border
            
                enemyHpBar.run(SKAction.resize(toWidth: originalBarSize * percentage, duration: 0.03))
        }
        
        update(sknode: ofTarget)
        
        if (ofTarget.hp > -5000 && ofTarget.hp <= 0){
            ofTarget.hp = -9999
            
            enemyHpBar.removeFromParent()
            explode(sknode: ofTarget)
            return
        }
        else{
            if enemyHpBar.isHidden {
                enemyHpBar.isHidden = false
            }
        }
    }
    
    internal func setPosition(position pos:CGPoint){
        self.position = pos
        (self.originX, self.originY) = (self.position.x, self.position.y)
    }
    
    internal func update(sknode: SKSpriteNode){
        
        if let enemyHP = sknode.childNode(withName: "hpBar"){
            
            let percentage = sknode.hp/sknode.maxHp
            
            if (percentage < 0.3){
                enemyHP.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.1))
            }
                
            else if (percentage < 0.55){
                enemyHP.run(SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0.1))            }
        }
        
    }
    
    internal func explode(sknode: SKSpriteNode){
        
        
        let rewardCount:Int = randomInt(min: 1, max: 4)
        
        var posX = sknode.position.x
        var posY = sknode.position.y
        
        if self.enemyType == .Regular{
            // converting to position in scene's view... required because its parent is not the root view
            posX = sknode.position.x + screenSize.width/2
            posY = sknode.parent!.frame.size.height/2 + 200 + sknode.position.y  + screenSize.height
        }
        
        for _ in 0..<rewardCount{
            
            let reward = currency?.createCoin(posX: posX, posY: posY, width: 30, height: 30, createPhysicalBody: true, animation: true)
            
            
            let impulse = CGVector(dx: random(min: -25, max: 25), dy: random(min:10, max:35))
            
            reward?.run(SKAction.sequence([SKAction.applyForce(impulse , duration: 0.2), SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
            
            if let r = reward{
                delegate?.addChild(r)
            }
            else{
                
                print("ERROR ON CLASS ENEMY. Check Method Explosion. ")
            }
        }
        
        sknode.removeAllActions()
        
        // print("Enemy.Swift - LOOK THE SIZE OF ACTIONDEAD: \(actionsDead.count)")
        switch (enemyType){
        case .Boss:
            // print ("DISPLAY ANIMATION")
            sknode.physicsBody?.categoryBitMask = PhysicsCategory.None
            sknode.run( SKAction.sequence([SKAction.animate(with: actionsDead, timePerFrame: 0.11),SKAction.run {
                sknode.removeFromParent()
                // update gameinfo state
                self.delegate?.changeGameState(.WaitingState)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
