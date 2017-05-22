//
//  StartGame.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/22/16.
//  Copyright © 2016 Wong. All rights reserved.
//

// Height: 736, Width: 414  -> iPhone 7 Plus

import Foundation
import SpriteKit
import AVFoundation

/* LEGACY VARIABLES... NOW USING ATLAS */
let PLAYER_SPRITES_DIR = "Sprites/Player"
let ENEMY_SPRITES_DIR = "Sprites/Enemy/Standard"
let BOSS_SPRITES_DIR = "Sprites/Enemy/Boss"
let ITEMS_SPRITES_DIR = "Sprites/Items"

let SOUND_EFFECT_PUFF = "SoundEffects/puff.m4a"
let SOUND_EFFECT_COIN = "SoundEffects/getcoin.m4a"
/* END OF LEGACY VARIABLES. REMOVE IT LATER */

class StartGame:SKScene, SKPhysicsContactDelegate{
    
     deinit{
     print("STARTGAME is being deInitialized. REMOVE THIS FUNCTION WHEN IT IS SENDING TO APPSTORE");
     }
    
    var gameinfo = GameInfo()
    
    override func didMove(to view: SKView) {
        
        removeUIViews()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        
            self.view?.addGestureRecognizer(gestureRecognizer)
        
        
        self.anchorPoint = CGPoint(x: 0, y: 0)

        
        
        print ("Y: \(view.bounds.size.height)")
        print ("X: \(view.bounds.size.width)")
        
       
        load()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // good
        movingSky()
       // let toon = gameinfo.account.getCurrentToon()
        
    }

    func load(){
        
        // For Debug Use only
        view?.showsPhysics = false
        
        // Setting up delegate for Physics World & Set up gravity
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        let bground1 = SKSpriteNode()
        bground1.texture = SKTexture(imageNamed: "backgrounds/type1/bg\(randomInt(min: 1, max: 6)).png")
        bground1.size = CGSize(width: screenSize.width, height: screenSize.height)
        bground1.position = CGPoint(x: screenSize.width/2, y: 0)
        bground1.zPosition = -1
        bground1.name = "sky"
        self.addChild(bground1)
        
        let bground2 = SKSpriteNode()
        bground2.texture = SKTexture(imageNamed: "backgrounds/type1/bg\(randomInt(min: 1, max: 6)).png")
        bground2.size = CGSize(width: screenSize.width, height: screenSize.height)
        bground2.position = CGPoint(x: screenSize.width/2, y: screenSize.height)
        bground2.name = "sky"
        bground2.zPosition = -1
        self.addChild(bground2)
 
        // Check if any error from loading gameinfo
        let check = gameinfo.load(scene: self)
        
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }
        
        gameinfo.account.getCurrentToon().getNode().run(SKAction.scale(by: 0.8, duration: 0.1))
       
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.run(gameinfo.update), SKAction.wait(forDuration: 0.01)]))
        gameinfo.start()
     //   run(SKAction.sequence([SKAction.wait(forDuration: 5.0), action]))
       run(action)
        
        
    }
    
    /* Maybe create a new file to handle background. For future update*/
    func movingSky(){
        self.enumerateChildNodes(withName: "sky", using: ({(node, error ) in
            node.position.y -= 2
            if (node.position.y <= -screenSize.height/2){
                node.position.y = screenSize.height*1.5
            }
            
        }))
    }
    
  @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        
        let toon = self.gameinfo.account.getCurrentToon()
        let player = toon.getNode()
        
        if recognizer.state == .began {
           // print ("GESTURE PAN started")
           // var touchLocation = recognizer.location(in: self.view)
           // touchLocation = self.convertPoint(fromView: touchLocation)
        
        } else if recognizer.state == .changed {
            let locomotion = recognizer.translation(in: recognizer.view)
           player.position.x = ceil(toon.getNode().position.x) + ceil((locomotion.x * 1.8))
            
          //  print (toon.getNode().position)
            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            if (player.position.x < 50 ){
                player.position.x = 50
            }
            else if (toon.getNode().position.x > 374){
                player.position.x = 374
            }
 
            if (locomotion.x < -1){
                player.run(SKAction.rotate(toAngle: 0.0872665, duration: 0.1))
            }
            else if (locomotion.x > 0.5){
               player.run(SKAction.rotate(toAngle: -0.0872665, duration: 0.1))
            }
            else if (locomotion.x == 0.0){
                player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            }
            
            toon.updateProjectile()
            
    
        } else if recognizer.state == .ended {
            player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
        }
        else if recognizer.state == .cancelled{
            print ("FAILED CANCEL")
        }
        else if recognizer.state == .failed{
            print ("FAILED")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var contactType:ContactType = .None
        var higherNode:SKSpriteNode?
        var lowerNode:SKSpriteNode?
  
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            higherNode = contact.bodyA.node as! SKSpriteNode?
            lowerNode = contact.bodyB.node as! SKSpriteNode?
        }
        else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            higherNode = contact.bodyB.node as! SKSpriteNode?
            lowerNode = contact.bodyA.node as! SKSpriteNode?
        }
        else{
            return
        }
        
        guard let h_node = higherNode, let l_node = lowerNode else {
            return
        }
        
        /*
         POSSIBLE CASES ( lowerNode vs HigherNode ):
         
         
         PLAYER & ENEMY  =  HitByEnemy  -> Description: Enemy hit the player
         PLAYER & COIN   =  GotCoin     -> Description: Player got money
         ENEMY  & Projectile = EnemyGotHit -> Description: Enemy hit By the player
         ALL    & IMUNE  =  Immune
         
         NOTE: None < Player < Enemy < Projectile < Currency < Wall < Imune
         
         NOTE2: Enemy's projectile are considered as Enemy. Thus, need to ignore when projectile hit enemy attack
         */
        
        
        if (h_node.physicsBody?.categoryBitMask == PhysicsCategory.Imune){
            contactType = .Immune
        }
   
        else if (l_node.name! == "Enemy_Regular" || l_node.name! == "Enemy_Boss" ) && h_node.name! == "bullet"{
                contactType = .EnemyGotHit
            }
        else if l_node.name! == "toon" && h_node.name! == "coin"{
            contactType = .PlayerGetCoin
        }
        
        else if l_node.name! == "toon" && h_node.name!.contains("Enemy"){
            contactType = .HitByEnemy
        }
        else if l_node.name!.contains("Enemy") && l_node.name!.contains("Attack") && h_node.name == "bullet"{
            // Handle case where bullet hit enemy's attack
            return
        }
        
        contactUpdate(lowNode: l_node, highNode: h_node, contactType: contactType)
    }

    func contactUpdate(lowNode: SKSpriteNode, highNode: SKSpriteNode, contactType:ContactType){
        let regular = gameinfo.enemy
        let boss = gameinfo.boss
        
        switch contactType{
            
        case .EnemyGotHit:
            // FX when enemy is hit
            let effect = gameinfo.account.getCurrentToon().getBullet().generateTouchedEnemyEmmiterNode(x: highNode.position.x, y: highNode.position.y)
            self.addChild(effect)
            // update enemy
            if lowNode.name!.contains("Regular"){
                regular.decreaseHP(ofTarget: lowNode, hitBy: highNode)
            }
            else if lowNode.name!.contains("Boss"){
                boss.decreaseHP(ofTarget: lowNode, hitBy: highNode)
            }
            else{
                print("WARNING: Should not reach here. Check contactUpdate in StartGame.swift")
            }
            destroy(sknode: highNode)
            
        case .HitByEnemy:
            
            // particle effect testing
            
            let hitparticle = SKEmitterNode()
            hitparticle.particleTexture = global.getMainTexture(main: .Gold)
            hitparticle.position = lowNode.position
            hitparticle.particleLifetime = 1
            hitparticle.particleBirthRate = 10
            hitparticle.numParticlesToEmit  = 30
            hitparticle.emissionAngleRange = 180
            hitparticle.particleScale = 0.2
            hitparticle.particleScaleSpeed = -0.2
            hitparticle.particleSpeed = 100
            self.addChild(hitparticle)
            
            lowNode.removeAllActions()
            lowNode.removeFromParent()
            highNode.removeAllActions()
            prepareToChangeScene()

        case .Immune:
            destroy(sknode: lowNode)
            
        case .PlayerGetCoin:
            self.run(self.gameinfo.mainAudio.getAction(type: .Coin))
            self.gameinfo.addCoin(amount: 1)
            destroy(sknode: highNode)
            
        case .None:
            break
        }
    }
    
    func destroy(sknode: SKSpriteNode){
        sknode.removeAllActions()
        sknode.removeFromParent()
    }
    
    func prepareToChangeScene(){
        // remove all gestures
        for gesture in (view?.gestureRecognizers)!{
            view?.removeGestureRecognizer(gesture)
        }

        // switch scene
        self.physicsWorld.speed = 0.4
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.run {
            // remove all delegates
            self.gameinfo.boss.delegate = nil
            self.gameinfo.enemy.delegate = nil
            
            // remove all children and its actions
            for childNode in self.children{
                childNode.removeAllActions()
            }
            self.removeAllChildren()
            self.removeAllActions()
            
            // stop background audio
            self.gameinfo.mainAudio.stop()
            let scene = EndGame(size: self.size)
            scene.collectedCoins = self.gameinfo.getCurrentGold()
            self.view?.presentScene(scene)
            }]))
        
    }
    
}
