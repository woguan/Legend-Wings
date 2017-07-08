//
//  Toon.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 1/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit

class Toon{
    
    enum Character:String{
        case Alpha = "Alpha"
        case Beta = "Beta"
        case Celta = "Celta"
        case Delta = "Delta"
        case Felta = "Felta"
        case Gelta = "Gelta"
    }
    deinit {
        print ("Toon class has been deinitiated.")
    }
    
   // private var description:[String]
    private var width:CGFloat
    private var height:CGFloat
    private var size:CGSize
    private var node:SKSpriteNode
    private var bullet:Projectile?
    private var description:[String] = []
    private var experience:CGFloat = 0
    private var charName:String = "None"
    private var title:String = "None"
    private var level:Int = 1 // Maximum level bullet can be switch to.
    private var bulletLevel:Int = 1
    
    // Initialize
    private var charType:Character
    
    init(char:Character){
        
        // Create PNG with height = 130 For good quality
        var localMainTexture:SKTexture!
        var localWingTexture:SKTexture!
        switch char {
        case .Alpha:
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        case .Beta:
            localMainTexture = global.getMainTexture(main: .Character_Beta)
            localWingTexture = global.getMainTexture(main: .Character_Beta_Wing)
        case .Celta:
            localMainTexture = global.getMainTexture(main: .Character_Celta)
            localWingTexture = global.getMainTexture(main: .Character_Celta_Wing)
        case .Delta:
            localMainTexture = global.getMainTexture(main: .Character_Delta)
            localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        default:
            // default - Warning
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        }
        
        self.charType = char
        self.size = localMainTexture.size()
        self.width = size.width //65 //
        self.height = size.height //130 //

        node = SKSpriteNode(texture: localMainTexture)
        node.name = "toon"
        node.position = CGPoint(x: screenSize.width/2, y: 100)
        node.size = CGSize(width: width, height: height)
        node.run(SKAction.scale(to: 0.7, duration: 0.0))
        
        let l_wing = SKSpriteNode()
        l_wing.texture = localWingTexture
        l_wing.size = localWingTexture.size()
        l_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        l_wing.position = CGPoint(x: -2.0, y: 20.0)
        l_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: 40, duration: 0.3), SKAction.resize(toWidth: 77, duration: 0.15)])))
        
        node.addChild(l_wing)
        
        let r_wing = SKSpriteNode()
        r_wing.texture = localWingTexture
        r_wing.size = localWingTexture.size()
        r_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        r_wing.position = CGPoint(x:2.0, y: 20.0)
        r_wing.xScale = -1.0
        r_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: 40, duration: 0.3), SKAction.resize(toWidth: 77, duration: 0.15)])))
        
        node.addChild(r_wing)
    }
    
    internal func load(infoDict:NSDictionary){
        //Level lv: Int, Experience exp: CGFloat, Description description:[String]
        self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! CGFloat
        self.description = infoDict.value(forKey: "Description") as! [String]
        self.title = infoDict.value(forKey: "Title") as! String
        self.charName = infoDict.value(forKey: "Name") as! String
        self.bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
            
        bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: bulletLevel)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false // not allow it to rotate
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
    }
    
    internal func getNode() -> SKSpriteNode{
        return node
    }

    internal func updateProjectile(){
        bullet!.setPosX(x: node.position.x)
    }
 
    internal func getBullet() -> Projectile{
        return bullet!
    }
    
    internal func getToonDescription() -> [String]{
        return description
    }
    
    internal func getToonName() -> String{
        return charName
    }
    
    internal func getToonTitle() -> String{
        return title
    }
    
    internal func getBulletLevel() -> Int{
        return bulletLevel
    }
    
    internal func getLevel() -> Int{
        return level
    }
}
