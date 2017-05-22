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

class Map{

    deinit {
        print("Map has been deinitialized")
    }
    private var maptextures:[SKTexture]
    private var bottomTexture:SKTexture
    private var midTexture:SKTexture
    private var topTexture:SKTexture
    private var currIndex:Int
    
    let top:SKSpriteNode
    let mid:SKSpriteNode
    let bottom:SKSpriteNode
    
    init(maps:[SKTexture], scene:SKScene){
        currIndex = randomInt(min: 0, max: maps.count - 3)
        maptextures = maps
        bottomTexture = maptextures[currIndex]
        midTexture = maptextures[currIndex + 1]
        topTexture = maptextures[currIndex + 2]
        currIndex = currIndex + 2
        
        // CGSize(width: screenSize.width, height: screenSize.height)
        let tsize = CGSize(width: screenSize.width, height: screenSize.width)
        
        mid = SKSpriteNode()
        mid.texture = midTexture
        mid.size = tsize
        mid.anchorPoint = CGPoint(x: 0.5, y: 0)
        mid.position = CGPoint(x: screenSize.width/2, y: mid.size.height/2)
        mid.zPosition = -5
        
        bottom = SKSpriteNode()
        bottom.texture = bottomTexture
        bottom.size = tsize
        bottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottom.position = CGPoint(x: screenSize.width/2, y: mid.position.y - mid.size.height)
        bottom.zPosition = -5
     
        top = SKSpriteNode()
        top.texture = topTexture
        top.size = tsize
        top.anchorPoint = CGPoint(x: 0.5, y: 0)
        top.position = CGPoint(x: screenSize.width/2, y: mid.position.y + mid.size.height)
        top.zPosition = -5
        // create function to start actrion for moving map
        
        (top.alpha, bottom.alpha, mid.alpha) = (0.0, 0.0, 0.0)
        
        scene.addChild(mid)
        scene.addChild(bottom)
        scene.addChild(top)
    }
    
    func makeNode() -> SKSpriteNode{
        let node = SKSpriteNode()
        return node
    }
    
    func fadein(){
        let fin = SKAction.fadeAlpha(to: 1, duration: 0.5)
        top.run(fin)
        mid.run(fin)
        bottom.run(fin)
    }
    func run(){
        let moveDown = SKAction.moveBy(x: 0, y: -2, duration: 0.01)
        mid.run(SKAction.repeatForever(moveDown))
        bottom.run(SKAction.repeatForever(moveDown))
        top.run(SKAction.repeatForever(moveDown))
    }
    
     func update(){
        if (bottom.position.y <= -bottom.size.height){
            bottom.texture = getNextTexture()
            bottom.position.y = top.position.y + top.size.height
        }
        else if top.position.y <= -top.size.height{
            top.texture = getNextTexture()
            top.position.y = mid.position.y + mid.size.height
        }
        else if mid.position.y <= -mid.size.height{
            mid.texture = getNextTexture()
            mid.position.y = bottom.position.y + bottom.size.height
        }
    }
     func getNextTexture() -> SKTexture{
        if currIndex + 1 >= maptextures.count {
            currIndex = 0
            return maptextures[0]
        }
        else{
            currIndex = currIndex + 1
            return maptextures[currIndex]
        }
        
    }
    
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
            actions = global.getTextures(textures: .Gold_Animation)
        default:
            actions = []
        }
        
    }
    
    func createCoin(posX:CGFloat, posY:CGFloat, width w: CGFloat, height h: CGFloat, createPhysicalBody:Bool, animation: Bool) -> SKSpriteNode{
       // let c = SKSpriteNode(imageNamed: coinSpriteName!)
        let c = SKSpriteNode(texture: global.getMainTexture(main: .Gold))
        //c.size = CGSize(width: 30, height: 30)
        c.size = CGSize(width: w, height: h)
        c.position = CGPoint(x: posX, y: posY)
        c.name = "coin"
        
        
        if (createPhysicalBody){
            //c.physicsBody =  SKPhysicsBody(texture: c.texture!, size: c.size)
            c.physicsBody = SKPhysicsBody(circleOfRadius: 15)
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
    
    func generateTouchedEnemyEmmiterNode(x posX:CGFloat, y posY:CGFloat) -> SKEmitterNode{
        
        let effect = SKEmitterNode()
        effect.position = CGPoint(x: posX, y: posY)
        effect.particleTexture = SKTexture(imageNamed: "particle.png")
        effect.particleSize = CGSize(width: 100, height: 100)
        effect.particleLifetime = 1
        effect.particleBirthRate = 1
        effect.numParticlesToEmit  = 3
        effect.emissionAngleRange = 180
        effect.particleScale = 0.4
        effect.particleScaleSpeed = -0.9
        effect.particleSpeed = 200
        
        /*effect.position = CGPoint(x: highNode.position.x, y: highNode.position.y)
         effect.particleTexture = SKTexture(imageNamed: "particle.png")
         effect.particleSize = CGSize(width: 250, height: 250)
         effect.particleLifetime = 1
         effect.particleBirthRate = 3000
         effect.numParticlesToEmit  = 2
         effect.emissionAngleRange = 180
         effect.particleScale = 0.2
         effect.particleScaleSpeed = -0.2
         effect.particleSpeed = 50*/
          effect.run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.removeFromParent()]))
        return effect
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

