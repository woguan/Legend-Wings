//
//  Structs.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/30/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let Imune       : UInt32 = UInt32.max
    static let Player   :UInt32 = 0b10
    static let Enemy   : UInt32 = 0b100
    static let Projectile : UInt32 = 0b1000
    static let Currency : UInt32 = 0b10000
    static let Wall: UInt32 = 0b1000000
    
}

struct Currency{
    
    enum CurrencyType{
        
        case Coin
        case RedJewel
        case WhiteJewel
        
    }
    
  //  private var coinSpriteName:String?
    private var actions:[SKTexture]
    var audioPlayer:AVAudioPlayer?
    
    init(type: CurrencyType, avaudio: AVAudio? = nil){
        
        
        switch type{
        case .Coin:
            actions = global.getTextures(animation: .Gold_Animation)
        default:
            actions = []
        }
        
    }
    
    func createCoin(posX:CGFloat, posY:CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{
       // let c = SKSpriteNode(imageNamed: coinSpriteName!)
        let c = SKSpriteNode(texture: global.getMainTexture(main: .Gold))
        c.size = CGSize(width: 30, height: 30)
        c.position = CGPoint(x: posX, y: posY)
        c.name = "coin"
        
        
        if (createPhysicalBody){
            c.physicsBody =  SKPhysicsBody(texture: c.texture!, size: c.size)
            c.physicsBody!.isDynamic = true // allow physic simulation to move it
            c.physicsBody!.categoryBitMask = PhysicsCategory.Currency
            c.physicsBody!.contactTestBitMask = PhysicsCategory.Player
            c.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        }
        
        if (animation){
            c.run(SKAction.repeatForever(SKAction.animate(with: actions, timePerFrame: 0.1)))
        }
        return c
        
    }
    
}


struct Projectile {
    var originX:CGFloat
    var originY:CGFloat
    var power:CGFloat
    var spriteName = "bullet.png"
    var name = "bullet"
    var bulletType:ProjectileType
    var size = CGSize(width: 30.0, height: 30.0)
    
    init (posX:CGFloat, posY:CGFloat){
        originX = posX
        originY = posY + 35
        
        // constant for now
        
        power = 25.0
        bulletType = .type1
    }
    
    func shoot() -> SKSpriteNode{
        
        let bullet = SKSpriteNode(imageNamed: spriteName)
        bullet.userData = NSMutableDictionary()
        bullet.name = name
        bullet.position = CGPoint(x: originX, y: originY)
        bullet.size = size
        
        bullet.power = self.power
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody!.isDynamic = true
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.allowsRotation = false
        
        bullet.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bullet.physicsBody!.collisionBitMask = 0
        bullet.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        
        bullet.run(SKAction.scale(to: 5, duration: 0.48))
        bullet.run(SKAction.sequence([SKAction.moveTo(y: 740, duration: 1), SKAction.removeFromParent()]))
        
        return bullet
    }
    mutating func setPosX(x:CGFloat){
        originX = x
    }
    
    mutating func setPosY(y:CGFloat){
        originY = y + 35
    }
    
}

