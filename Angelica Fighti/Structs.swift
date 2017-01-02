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
    
    private var coinSpriteName:String?
    private var actions:[SKTexture]
    var audioPlayer:AVAudioPlayer?
    
    init(type: CurrencyType, avaudio: AVAudio? = nil){
        
        
        switch type{
        case .Coin:
            coinSpriteName = "\(ITEMS_SPRITES_DIR)/Gold/main.png"
            actions = [SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action1"), SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action2"), SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action3"), SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action4"), SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action5"), SKTexture(imageNamed: "\(ITEMS_SPRITES_DIR)/Gold/action6")]
        default:
            coinSpriteName = "invalid"
            actions = []
        }
        
    }
    
    func createCoin(posX:CGFloat, posY:CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{
        let c = SKSpriteNode(imageNamed: coinSpriteName!)
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
    
    func playEffect(){
        var asd:AVAudioPlayer = AVAudioPlayer()
        asd = audioPlayer!
        asd.play()
    }
    
    
}
