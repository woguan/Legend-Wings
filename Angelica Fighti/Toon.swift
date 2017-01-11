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
    
    deinit {
        print ("Toon class has been deinitiated.")
    }
    
    private var width:CGFloat
    private var height:CGFloat
    private var node:SKSpriteNode
    private var bullet:Projectile
    
    private var actions:[SKTexture]
    

    
    init(w:CGFloat, h:CGFloat){
        width = w
        height = h
        
        node = SKSpriteNode(texture: global.getMainTexture(main: .Player_Toon_1))
       // node.color = SKColor.blue
        node.size = CGSize(width: width, height: height)
        node.position = CGPoint(x: 200, y: 100)
        node.name = "toon"
        actions = global.getTextures(animation: .Player_Toon_1_Animation)
        bullet = Projectile(posX: node.position.x, posY: node.position.y)
    }
    
    func load(){
        
        node.run(SKAction.repeatForever(SKAction.animate(with: actions, timePerFrame: 0.05)))
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false // not allow it to rotate
        // node.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
    }
    
    func getNode() -> SKSpriteNode{
        return node
    }
  /*  
    func changeSize(w:CGFloat, h:CGFloat){
        width = w
        height = h
    }
    */
    
    func updateProjectile(){
        //print ("new bullet position", node.position.x)
        bullet.setPosX(x: node.position.x)
        
    }
 
    func getBullet() -> Projectile{
        return bullet
    }
    
}
