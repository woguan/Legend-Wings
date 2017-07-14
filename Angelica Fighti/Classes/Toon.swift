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
        case Alpha = "ALPHA"
        case Beta = "BETA"
        case Celta = "CELTA"
        case Delta = "DELTA"
        case Felta = "FELTA"
        case Gelta = "GELTA"
        
        var string:String{
            let name = String(describing: self)
            return name
        }
    }
    deinit {
        print ("Toon class has been deinitiated.")
    }
    
    private var size:CGSize
    private var node:SKSpriteNode
    private var bullet:Projectile?
    private var description:[String] = []
    private var experience:CGFloat = 0
    private var title:String = "None"
    private var level:Int = 1 // For future use
    
    // Initialize
    private var charType:Character
    
    init(char:Character){
        
        var localMainTexture:SKTexture!
        var localWingTexture:SKTexture!
        var cw:CGFloat!
        var ch:CGFloat!
        var ww:CGFloat!
        var wh:CGFloat!
        switch char {
        case .Alpha:
            cw = screenSize.width * 0.150
            ch = screenSize.height * 0.177
            ww = screenSize.width * 0.186
            wh = screenSize.height * 0.081
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        case .Beta:
            cw = screenSize.width * 0.1135
            ch = screenSize.height * 0.175
            ww = screenSize.width * 0.191
            wh = screenSize.height * 0.083
            localMainTexture = global.getMainTexture(main: .Character_Beta)
            localWingTexture = global.getMainTexture(main: .Character_Beta_Wing)
        case .Celta:
            cw = screenSize.width * 0.135
            ch = screenSize.height * 0.163
            ww = screenSize.width * 0.179
            wh = screenSize.height * 0.091
            localMainTexture = global.getMainTexture(main: .Character_Celta)
            localWingTexture = global.getMainTexture(main: .Character_Celta_Wing)
        case .Delta:
            cw = screenSize.width * 0.121
            ch = screenSize.height * 0.1725
            ww = screenSize.width * 0.140
            wh = screenSize.height * 0.114
            localMainTexture = global.getMainTexture(main: .Character_Delta)
            localWingTexture = global.getMainTexture(main: .Character_Delta_Wing)
        default:
            // default - Warning
            localMainTexture = global.getMainTexture(main: .Character_Alpha)
            localWingTexture = global.getMainTexture(main: .Character_Alpha_Wing)
        }
        
        self.charType = char
        self.size = CGSize(width: cw, height: ch)

        node = SKSpriteNode(texture: localMainTexture)
        node.name = "toon"
        node.position = CGPoint(x: screenSize.width/2, y: 100)
        node.size = self.size
        node.run(SKAction.scale(to: 0.7, duration: 0.0))
        
        let l_wing = SKSpriteNode()
        l_wing.texture = localWingTexture
        l_wing.size = CGSize(width: ww, height: wh)
        l_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        l_wing.position = CGPoint(x: -2.0, y: 20.0)
        l_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.3), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)])))
        
        node.addChild(l_wing)
        
        let r_wing = SKSpriteNode()
        r_wing.texture = localWingTexture
        r_wing.size = CGSize(width: ww, height: wh)
        r_wing.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        r_wing.position = CGPoint(x:2.0, y: 20.0)
        r_wing.xScale = -1.0
        r_wing.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.3), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)])))
        
        node.addChild(r_wing)
    }
    
    internal func load(infoDict:NSDictionary){
        //Level lv: Int, Experience exp: CGFloat, Description description:[String]
        self.level = infoDict.value(forKey: "Level") as! Int
        self.experience = infoDict.value(forKey: "Experience") as! CGFloat
        self.description = infoDict.value(forKey: "Description") as! [String]
        self.title = infoDict.value(forKey: "Title") as! String
        let bulletLevel = infoDict.value(forKey: "BulletLevel") as! Int
        
        bullet = Projectile(posX: node.position.x, posY: node.position.y, char: self.charType, bulletLevel: bulletLevel)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false // not allow it to rotate
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        
        // Apply Magnetic Field
        let mfield = SKFieldNode.radialGravityField()
        mfield.region = SKRegion(radius: Float(node.size.width))
        mfield.strength = 120.0
        mfield.categoryBitMask = GravityCategory.Player
        node.addChild(mfield)
        
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
        return charType.rawValue
    }
    
    internal func getToonTitle() -> String{
        return title
    }
    
    internal func getBulletLevel() -> Int{
        //return bulletLevel
        return bullet!.getBulletLevel()
    }
    
    internal func getLevel() -> Int{
        return level
    }
    
    internal func advanceBulletLevel() -> Bool{
        return bullet!.upgrade()
    }
    // Remove below function later on. Combine it with getToonName
    internal func getCharacter() -> Character{
        return charType
    }
}
