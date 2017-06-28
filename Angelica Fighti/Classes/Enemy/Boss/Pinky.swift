//
//  Pinky.swift
//  MonsterBuilder
//
//  Created by Guan Wong on 6/25/17.
//  Copyright © 2017 Guan Wong. All rights reserved.
//

import Foundation
import SpriteKit

class Pinky:SKSpriteNode{
    
    // fileprivate
    let body = SKSpriteNode()
    let leftEar = SKSpriteNode()
    let rightEar = SKSpriteNode()
    let leftEye = SKSpriteNode()
    let rightEye = SKSpriteNode()
    let leftEyebrow = SKSpriteNode()
    let rightEyebrow = SKSpriteNode()
    let leftWing = SKSpriteNode()
    let rightWing = SKSpriteNode()
    let root = SKSpriteNode()
    
    fileprivate var life:Int = 0
    
    var leftWingText = [SKTexture]()
    var rightWingText = [SKTexture]()
    
    
    convenience init(hp:CGFloat, lives:Int, isClone:Bool){
        self.init()
        self.userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        self.name = isClone ? "mainClonePinky" : "mainPinky"
        life = lives
        size = CGSize(width: 157, height: 170)
        
        setUp()
    }
    
    private func setUp(){
        
        root.userData = NSMutableDictionary()
        root.alpha = 0
        root.zPosition = 2
        root.size = CGSize(width: 157, height: 170)
        root.hp = hp
        root.maxHp = hp
        root.name = "root"
        root.position = CGPoint(x: screenSize.size.width/2, y: screenSize.size.height - size.height/2 - leftEar.size.height/2)
        self.addChild(root)
        
        body.texture = global.getMainTexture(main: .Boss_Pinky_Body)
        body.name = Global.Main.Boss_Pinky_Body.rawValue
        body.size = CGSize(width: 157, height: 170)
        root.addChild(body)
        
        leftEar.texture = global.getMainTexture(main: .Boss_Pinky_Left_Ear)
        leftEar.name = Global.Main.Boss_Pinky_Left_Ear.rawValue
        leftEar.size = CGSize(width: 40, height: 48)
        root.addChild(leftEar)
        leftEar.anchorPoint = CGPoint(x: 1, y: 0)
        leftEar.position = CGPoint(x: -15, y: 50)
        
        rightEar.texture = global.getMainTexture(main: .Boss_Pinky_Right_Ear)
        rightEar.name = Global.Main.Boss_Pinky_Right_Ear.rawValue
        rightEar.size = CGSize(width: 40, height: 48)
        root.addChild(rightEar)
        rightEar.anchorPoint = CGPoint(x: 0, y: 0)
        rightEar.position = CGPoint(x: 15, y: 50)
        
        leftEye.texture = global.getMainTexture(main: .Boss_Pinky_Left_Eye)
        leftEye.name = Global.Main.Boss_Pinky_Left_Eye.rawValue
        leftEye.size = CGSize(width: 31, height: 29)
        leftEye.position = CGPoint(x: -30, y: 25)
        root.addChild(leftEye)
        
        rightEye.texture = global.getMainTexture(main: .Boss_Pinky_Right_Eye)
        rightEye.name = Global.Main.Boss_Pinky_Right_Eye.rawValue
        rightEye.size = CGSize(width: 31, height: 29)
        rightEye.position = CGPoint(x: 30, y: 25)
        root.addChild(rightEye)
        
        leftEyebrow.texture = global.getMainTexture(main: .Boss_Pinky_Left_EyeBrow)
        leftEyebrow.size = CGSize(width: 29, height: 24)
        leftEyebrow.position = CGPoint(x: -30, y: 35)
        root.addChild(leftEyebrow)
        
        rightEyebrow.texture = global.getMainTexture(main: .Boss_Pinky_Right_EyeBrow)
        rightEyebrow.size = CGSize(width: 29, height: 24)
        rightEyebrow.position = CGPoint(x: 28, y: 35)
        root.addChild(rightEyebrow)
        
        leftWing.texture = global.getMainTexture(main: .Boss_Pinky_Left_Wing)
        leftWing.name = Global.Main.Boss_Pinky_Left_Wing.rawValue
        leftWing.anchorPoint = CGPoint(x: 1, y: 0)
        leftWing.size = CGSize(width: 42, height: 39)
        leftWing.position = CGPoint(x: -50, y: 55)
        leftWing.zPosition = 1
        root.addChild(leftWing)
        
        rightWing.texture = global.getMainTexture(main: .Boss_Pinky_Right_Wing)
        rightWing.name = Global.Main.Boss_Pinky_Right_Wing.rawValue
        rightWing.anchorPoint = CGPoint(x: 0, y: 0)
        rightWing.size = CGSize(width: 42, height: 39)
        rightWing.position = CGPoint(x: 50, y: 55)
        rightWing.zPosition = 1
        root.addChild(rightWing)
        
        leftWingText.append(global.getMainTexture(main: .Boss_Pinky_Left_Wing))
        leftWingText.append(global.getMainTexture(main: .Boss_Pinky_Left_Middle_Wing))
        leftWingText.append(global.getMainTexture(main: .Boss_Pinky_Left_Flipped_Wing))
        leftWingText.append(global.getMainTexture(main: .Boss_Pinky_Left_Middle_Wing))
        leftWingText.append(global.getMainTexture(main: .Boss_Pinky_Left_Wing))
        
        
        rightWingText.append(global.getMainTexture(main: .Boss_Pinky_Right_Wing))
        rightWingText.append(global.getMainTexture(main: .Boss_Pinky_Right_Middle_Wing))
        rightWingText.append(global.getMainTexture(main: .Boss_Pinky_Right_Flipped_Wing))
        rightWingText.append(global.getMainTexture(main: .Boss_Pinky_Right_Middle_Wing))
        rightWingText.append(global.getMainTexture(main: .Boss_Pinky_Right_Wing))
        
        
        root.physicsBody = SKPhysicsBody(circleOfRadius: body.size.width/2)
        root.physicsBody!.isDynamic = true
        root.physicsBody!.affectedByGravity = false
        root.physicsBody!.categoryBitMask = PhysicsCategory.Imune
        root.physicsBody!.friction = 0
        root.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        root.physicsBody!.restitution = 1
        root.physicsBody!.allowsRotation = false
        root.physicsBody!.linearDamping = 0
        
        setInitialAction()
        
    }
    
    private func setInitialAction(){
        root.run(SKAction.fadeIn(withDuration: 4))
        setAnimation()
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.run {
            self.root.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            self.move()
            }]))
    }
    
    private func setAnimation(){
        
        // Wing Action
        let wingDefaultState = SKAction.rotate(toAngle: 0, duration: 0.25)
        let leftWingAction = SKAction.rotate(toAngle: 1.2, duration: 0.25)
        let rightWingAction = SKAction.rotate(toAngle: -1.2, duration: 0.25)
        let leftWingSeq = SKAction.sequence([leftWingAction, wingDefaultState])
        let rightWingSeq = SKAction.sequence([rightWingAction, wingDefaultState])
        
        let leftWingTextureAnimation = SKAction.animate(with: leftWingText, timePerFrame: 0.1)
        let rightWingTextureAnimation = SKAction.animate(with: rightWingText, timePerFrame: 0.1)
        
        leftWing.run(SKAction.repeatForever(SKAction.group([leftWingSeq, leftWingTextureAnimation])))
        
        rightWing.run(SKAction.repeatForever(SKAction.group([rightWingSeq, rightWingTextureAnimation])))
        
        // Ear Action
        let earDefault = SKAction.rotate(toAngle: 0.0, duration: 1.5)
        let leftEarAction = SKAction.rotate(toAngle: -0.4, duration: 1.5)
        let rightEarAction = SKAction.rotate(toAngle: 0.4, duration: 1.5)
        
        leftEar.run(SKAction.repeatForever(SKAction.sequence([earDefault, leftEarAction])))
        rightEar.run(SKAction.repeatForever(
            SKAction.sequence([earDefault, rightEarAction])))
        
        // Body Action
        let bodyResizeAction = SKAction.scaleX(by: 1.02, y: 1, duration: 0.5)
        let bodyActionDown = SKAction.moveBy(x: 0, y: -10, duration: 0.5)
        let bodyActionUp = SKAction.moveBy(x: 0, y: 10, duration: 0.6)
        root.run(SKAction.repeatForever(SKAction.sequence([bodyActionDown, SKAction.wait(forDuration: 0.2),  bodyActionUp])))
        body.run(SKAction.repeatForever(SKAction.sequence([bodyResizeAction, bodyResizeAction.reversed()])))
        
    }
    
    private func move(){
        let vector = CGVector(dx: random(min: -30, max: 30), dy: random(min: -2.0, max: -0.5))
        root.run(SKAction.applyImpulse(vector, duration: 0.1))
        
        // whenever it moves, it has change to attack
        root.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            let r = randomInt(min: 0, max: 100)
            if r <= 8{
                self.attack()
            }
            else if self.root.position.y < screenSize.height/3{
                
            }
            }, SKAction.wait(forDuration: 2)])))
    }
    
    internal func attack(){
        // remove all actions
        defaultState()
        
        // Set up Actions
        
        leftEar.run(SKAction.rotate(toAngle: -0.4, duration: 0.25))
        rightEar.run(SKAction.rotate(toAngle: 0.4, duration: 0.25))
        
        leftWing.run(SKAction.rotate(toAngle: -0.3, duration: 0.25))
        rightWing.run(SKAction.rotate(toAngle: 0.3, duration: 0.25))
        leftWing.texture = global.getMainTexture(main: .Boss_Pinky_Left_Wing)
        rightWing.texture = global.getMainTexture(main: .Boss_Pinky_Right_Wing)
        let moveDown = SKAction.moveTo(y: self.root.size.height/2 - self.position.y, duration: 2.5)
        let moveUp = SKAction.moveTo(y: screenSize.height - self.root.size.height/2 - self.leftEar.size.height/2 - self.position.y, duration: 2)
        let groupAction = SKAction.group([moveUp, SKAction.run(setAnimation)])
        
        root.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), moveDown, groupAction, SKAction.run(move)]))
        
    }
    
    func multiply(){
        
        if self.life == 0 {
            self.root.removeFromParent()
            return
        }
        
        self.life -= 1
        defaultState()
        
        let cloneOne = Pinky(hp: self.maxHp * 0.8, lives: life, isClone: true)
        let cloneTwo = Pinky(hp: self.maxHp * 0.8, lives: life, isClone: true)
        
        
        guard let rootOne = cloneOne.childNode(withName: "root"),
            let rootTwo = cloneTwo.childNode(withName: "root") else{
                return
        }
        
        rootOne.position = self.root.position
        rootTwo.position = self.root.position
        
        rootOne.run(SKAction.scale(by: 0.2 * CGFloat(life) + 0.4, duration: 0))
        rootTwo.run(SKAction.scale(by: 0.2 * CGFloat(life) + 0.4, duration: 0))
        
        self.addChild(cloneOne)
        self.addChild(cloneTwo)
        
        root.physicsBody!.contactTestBitMask = PhysicsCategory.Imune
        
        let scaleX = SKAction.scaleX(to: 0.7, duration: 0.3)
        let scaleS = SKAction.scale(by: 0.7, duration: 0.3)
        let scaleAction = SKAction.group([scaleX, scaleS])
        
        let leye = root.childNode(withName: Global.Main.Boss_Pinky_Left_Eye.rawValue) as! SKSpriteNode
        let reye = root.childNode(withName: Global.Main.Boss_Pinky_Right_Eye.rawValue) as! SKSpriteNode
        leye.texture = global.getMainTexture(main: .Boss_Pinky_Left_Damaged_Eye)
        reye.texture = global.getMainTexture(main: .Boss_Pinky_Right_Damaged_Eye)
        
        
        
        root.run(SKAction.sequence([scaleAction, SKAction.removeFromParent(), SKAction.run {
            rootOne.physicsBody!.velocity = CGVector(dx: 25, dy: -0.5)
            rootTwo.physicsBody!.velocity = CGVector(dx: -25, dy: -0.5)
            }]))
        
    }
    
    private func defaultState(){
        
        // Remove all actions and reset to defautl state
        leftWing.removeAllActions()
        rightWing.removeAllActions()
        leftEar.removeAllActions()
        rightEar.removeAllActions()
        body.removeAllActions()
        root.removeAllActions()
        
        body.run(SKAction.scaleX(to: 1, duration: 0.25))
        leftEar.run(SKAction.rotate(toAngle:  0.0, duration: 0.25))
        rightEar.run(SKAction.rotate(toAngle: 0.0, duration: 0.25))
        leftWing.run(SKAction.rotate(toAngle: 0.0, duration: 0.25))
        rightWing.run(SKAction.rotate(toAngle: 0.0, duration: 0.25))
        root.physicsBody?.velocity = CGVector.zero
        
    }
    
}
