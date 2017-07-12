//
//  Fireball.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/27/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class Fireball:Enemy {
    
    private var currency:Currency = Currency(type: .Coin)
    private var velocity = CGVector.zero
    private var target:SKSpriteNode?
    
    convenience init(target:SKSpriteNode, speed:CGVector){
        self.init(hp: 10)
        self.target = target
        name = "Enemy_Fireball"
        size = CGSize(width: screenSize.size.width/5, height: screenSize.height/5)
        position = CGPoint.zero
        velocity = speed
        
        currency  = Currency(type: .None)
        initialSetup()
        applyAI()
    }
    
    private func initialSetup(){
        
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
            sknode.size = CGSize(width: screenSize.width/5 * 0.9, height: screenSize.height/6.51)
            sknode.anchorPoint = CGPoint(x: 0.5, y: 0)
            sknode.position.y = -screenSize.height/4.74/2
            sknode.run(animation)
            return sknode
        }
        
        // Enemymodel
        self.position.y = screenSize.height - self.size.height
        self.color = .clear
        
        
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
        track.position.y = -self.size.height/3
        track.texture = trackerTexture
        track.run(SKAction.sequence([scaleAction, blink, sblink]))
        self.addChild(track)
        
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
        auranode.position.y = screenSize.height/2
        self.addChild(auranode)
        
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
        auranode.physicsBody!.fieldBitMask = GravityCategory.None // Not affect by magnetic
        auranode.physicsBody!.velocity.dy = 0

        
    }
    
    private func applyAI(){
        guard let target = self.target else{
            print("player not exist")
            return
        }
        let setVelocity = SKAction.sequence([SKAction.run {
            self.childNode(withName: self.name!)!.physicsBody!.velocity.dy = -400
            }])
        
        let AIMove = SKAction.run {
            if self.position.x < target.position.x{
                self.position.x += 0.3
            }
            else if self.position.x > target.position.x{
                self.position.x -= 0.3
            }
        }
        
        let repeatAI = SKAction.repeat(SKAction.sequence([AIMove, SKAction.wait(forDuration: 0.01)]), count: 80)
        
        let AIAction = SKAction.sequence([SKAction.wait(forDuration: 0.2), AIMove, repeatAI, SKAction.wait(forDuration: 0.5)])
        
        position.x = target.position.x
        
        self.run(SKAction.sequence([AIAction, setVelocity, SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
    }
    
    internal func setTarget(target:SKSpriteNode){
        self.target = target
    }
}

