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
        print("Enemy Class Deinitiated")
    }
    
    enum EnemyType{
        case Boss
        case Regular
        case Fireball
        case Special
    }
    
    enum BossType{
        case None
        case Pinky
        case Bomber
    }
    
    
    // Shared Variables
    private var enemyType:EnemyType
    private var enemyModel:SKSpriteNode!
    private var currency:Currency?
    private var bossType:BossType
    
    private var baseHP:CGFloat = 0
    private var velocity:CGVector = CGVector.zero
    
    
    var delegate:GameInfoDelegate?
    
    init(type: EnemyType){
        currency = Currency(type: .Coin)
        enemyType = type
        enemyModel = SKSpriteNode()
        bossType = .None
        
        super.init()
    }
    
    internal func spawn(scene :SKScene){
        
        switch enemyType {
        case .Regular:
            enemyModel = RegularEnemy(baseHp: 100.0)
    
        case .Boss:
            let r = randomInt(min: 0, max: 100)
                if r < 50{
                    bossType = .Bomber
                    enemyModel = Bomber(hp: 2000)
                }
                else{
                    bossType = .Pinky
                    enemyModel = Pinky(hp: 2000.0, lives: 2, isClone: false)
                }
            
        case .Fireball:
            enemyModel = Fireball(target: (delegate?.getCurrentToonNode())!)

        default:
            break
        }
        
        scene.addChild(enemyModel!)
    }
    
    internal func increaseDifficulty(){
        // Increase HP & Speed
        switch enemyType {
        case .Regular:
            guard let model = enemyModel as? RegularEnemy else{
                print("FAIL TO CAST")
                return
            }
            model.raiseBaseHp(byValue: 100)
            model.raiseVelocity(byValue: 100)
        default:
            print("no increase")
        }
    }
    
    internal func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode){
        
        guard let enemyHpBar = ofTarget.childNode(withName: "hpBar") else{
            return
        }
        
        hitBy.physicsBody?.categoryBitMask = PhysicsCategory.None
        ofTarget.hp = ofTarget.hp - hitBy.power
        
        
        if (hitBy.name == "bullet"){
            
            let percentage = ofTarget.hp > 0.0 ? ofTarget.hp/ofTarget.maxHp : 0.0
            
            
            let bar = enemyHpBar.childNode(withName: "hpBorder")! as! SKShapeNode
            let originalBarSize = bar.frame.width * 0.98 // Note: barSize = 0.98 * border
            
            enemyHpBar.run(SKAction.resize(toWidth: originalBarSize * percentage, duration: 0.03))
          
            update(sknode: ofTarget)
            
            if (ofTarget.hp <= 0){
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
        
        switch (enemyType){
        case .Boss:
            if bossType == .Bomber{
                
                let mainBoss = enemyModel as! Bomber
                mainBoss.defeated()
                self.delegate?.changeGameState(.WaitingState)
            }
            else if bossType == .Pinky{
                let minion = sknode.parent! as! Pinky
                minion.multiply()
                
                let mainBoss = enemyModel as! Pinky
                
                if mainBoss.isDefeated(){
                    self.delegate?.changeGameState(.WaitingState)
                }
            }
            
        case .Regular:
            let mainReg = enemyModel as! RegularEnemy
            mainReg.defeated(sknode: sknode)
            sknode.run((delegate?.mainAudio.getAction(type: .Puff))!)
        default:
            sknode.removeFromParent()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
