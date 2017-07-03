//
//  Projectile.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit

struct Projectile {
    var originX:CGFloat
    var originY:CGFloat
    var power:CGFloat
    var spriteName = "bullet.png"
    var name = "bullet"
    var bulletType:ProjectileType
    var size = CGSize(width: 30.0, height: 30.0)
    
    var bulletnode:SKSpriteNode?
    
    init (posX:CGFloat, posY:CGFloat){
        originX = posX
        originY = posY + 35
        
        // constant for now
        
        power = 25.0
        bulletType = .type1
        
        
        bulletnode = SKSpriteNode()
        bulletnode!.texture = global.getMainTexture(main: .Character_Alpha_Bullet_Level_1)
        bulletnode!.size = size
        
        bulletnode!.userData = NSMutableDictionary()
        bulletnode!.power = power
        bulletnode!.name = name
        bulletnode!.physicsBody = SKPhysicsBody(texture: bulletnode!.texture!, size: bulletnode!.size)
        
        bulletnode!.physicsBody!.isDynamic = true
        bulletnode!.physicsBody!.affectedByGravity = false
        bulletnode!.physicsBody!.allowsRotation = false
        bulletnode!.physicsBody!.velocity = CGVector(dx: 0, dy: 1300)
        bulletnode!.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bulletnode!.physicsBody!.collisionBitMask = 0
        bulletnode!.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Imune
    }
    
    func shoot() -> SKSpriteNode{
        
        let bullet = bulletnode!.copy() as! SKSpriteNode
        bullet.position = CGPoint(x: originX, y: originY)
        bullet.run(SKAction.scale(to: 3, duration: 0.28))
        bullet.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()]))
        return bullet
    }
    
    func generateTouchedEnemyEmmiterNode(x posX:CGFloat, y posY:CGFloat) -> SKEmitterNode{
        
        let effect = SKEmitterNode(fileNamed: "bulling.sks")
        effect!.position = CGPoint(x: posX, y: posY)
        
        effect!.run(SKAction.sequence([SKAction.wait(forDuration: Double(effect!.particleLifetime)), SKAction.removeFromParent()]))
        return effect!
    }
    
    mutating func setPosX(x:CGFloat){
        originX = x
    }
    
    mutating func setPosY(y:CGFloat){
        originY = y + 35
    }
    
    func printPosition(){
        print ("This: ", originX, originY)
    }
    
}
