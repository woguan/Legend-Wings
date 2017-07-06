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
    var name = "bullet"
    var bulletnode:SKSpriteNode
    let bulletMaker = BulletMaker()
    
    init (posX:CGFloat, posY:CGFloat, char:Toon.Character, bulletLevel: Int){
        originX = posX
        originY = posY + 35
        
        if let blevel = BulletMaker.Level(rawValue: bulletLevel){
           bulletnode = bulletMaker.make(level: blevel, char: char)
            //bulletnode = bulletMaker.make(level: .Level_50, char: char)
        }
        else{
            print("Invalid bullet level. Returning 1")
            bulletnode = bulletMaker.make(level: .Level_1, char: char)
        }

        power = 25.0 * CGFloat(bulletLevel)
        
        bulletnode.userData = NSMutableDictionary()
        bulletnode.power = 25.0
        bulletnode.name = name
        bulletnode.setScale(0.25)
        bulletnode.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        bulletnode.physicsBody!.affectedByGravity = false
        bulletnode.physicsBody!.collisionBitMask = 0
        bulletnode.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bulletnode.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Imune
        bulletnode.physicsBody!.allowsRotation = false
        bulletnode.physicsBody!.velocity = CGVector(dx: 0, dy: 1500)
        
    }
    
    func shoot() -> SKSpriteNode{
        
        let bullet = bulletnode.copy() as! SKSpriteNode
        
        bullet.position = CGPoint(x: originX, y: originY)
         bullet.run(SKAction.scale(to: 1.0, duration: 0.2))
              bullet.run(SKAction.sequence([SKAction.wait(forDuration: 0.38), SKAction.removeFromParent()]))
        
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
