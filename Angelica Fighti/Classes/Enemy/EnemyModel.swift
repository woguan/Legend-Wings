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
        print("EnemyModel Class Deinitiated")
    }
    
    enum EnemyType: String{
        case Boss = "Boss Type"
        case Regular = "Regular Type"
        case Fireball = "Fireball Type"
        case Special = "Special Type"
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
    private var BossBaseHP:CGFloat = 1500.0
    private var RegularBaseHP:CGFloat = 100.0
    
    
    private var velocity:CGVector = CGVector(dx: 0, dy: -350)
    
    
    // Boss Variables - Implement later
    private let PinkyPercentage:Int = 100
    private let BomberPercentage:Int = 0
    
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
            enemyModel = RegularEnemy(baseHp: RegularBaseHP, speed: velocity)
        case .Boss:
            let chance = randomInt(min: 0, max: 100)
                if chance < 50{
                    bossType = .Bomber
                    enemyModel = Bomber(hp: BossBaseHP)
                }
                else{
                    bossType = .Pinky
                    enemyModel = Pinky(hp: BossBaseHP, lives: 2, isClone: false)
                }
            
        case .Fireball:
            enemyModel = Fireball(target: (delegate?.getCurrentToonNode())!, speed: velocity)
        default:
            break
        }
        
        scene.addChild(enemyModel!)
    }
    
    internal func increaseDifficulty(){
        // Increase HP & Speed
        switch enemyType {
        case .Regular:
            RegularBaseHP += 100
            velocity.dy -= 50
        case .Boss:
            BossBaseHP += 1500
        case .Fireball:
            velocity.dy -= 250
        default:
            print("No increase for \(enemyType.rawValue)")
        }
    }
    
    internal func decreaseHP(ofTarget: SKSpriteNode, hitBy: SKSpriteNode){
        
        
        guard let rootBar = ofTarget.childNode(withName: "rootBar") as? SKSpriteNode,
              let enemyHpBar = rootBar.childNode(withName: "hpBar")
              else {return}
        
        guard let ofTarget = ofTarget as? Enemy else{
            return
        }
        
        ofTarget.hp = ofTarget.hp - hitBy.power
        
        if (hitBy.name == "bullet"){
            let percentage = ofTarget.hp > 0.0 ? ofTarget.hp/ofTarget.maxHp : 0.0
            let originalBarSize = rootBar.size.width
                enemyHpBar.run(SKAction.resize(toWidth: originalBarSize * percentage, duration: 0.03))
                update(sknode: ofTarget, hpBar: enemyHpBar)
            if (ofTarget.hp <= 0){
                ofTarget.physicsBody?.categoryBitMask = PhysicsCategory.None
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
    
    internal func update(sknode: SKSpriteNode, hpBar: SKNode){
        guard let sknode = sknode as? Enemy else{
            return
        }
        
        let percentage = sknode.hp/sknode.maxHp
        if (percentage < 0.3){
                hpBar.run(SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.1))
            }
        else if (percentage < 0.55){
                hpBar.run(SKAction.colorize(with: .yellow, colorBlendFactor: 1, duration: 0.1))
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
                print("calling is defeated....")
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
