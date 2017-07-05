//
//  Extensions.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/30/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit
import UIKit



protocol ProjectileDelegate{
    
    func add(sknode: SKNode)
}

enum GameState{
    case Spawning  // state which waves are incoming
    case BossEncounter // boss encounter
    case WaitingState // Need an state
    case NoState
    case Start
}

//enum ProjectileType{
//    case type1
//    case type2
//    case type3
//    
//}

enum ContactType{
    case HitByEnemy
    case EnemyGotHit
    case PlayerGetCoin
    case Immune
    case None
}



extension SKNode{
    var power:CGFloat!{
        get {
            
            if let v = userData?.value(forKey: "power") as? CGFloat{
                return v
            }
            else{
                print ("Extension SKNode Error for POWER Variable: ",  userData?.value(forKey: "power") ?? -1.0 )
                return -9999.0
            }
            
        }
        set(newValue) {
            userData?.setValue(newValue, forKey: "power")
        }
    }
    
    var hp:CGFloat!{
        get {
            
            if let v = userData?.value(forKey: "hp") as? CGFloat{
                return v
            }
            else{
                print ("Extension SKNode Error for HP Variable: ",  userData?.value(forKey: "hp") ?? -1.0 )
                return -9999.0
            }
            
        }
        
        set(newValue) {
            userData?.setValue(newValue, forKey: "hp")
        }
    }
    
    var maxHp:CGFloat!{
        get {
            
            if let v = userData?.value(forKey: "maxHp") as? CGFloat{
                return v
            }
            else{
                print ("Extension SKNode Error for maxHp Variable: ",  userData?.value(forKey: "maxHp") ?? -1.0 )
                return -9999.0
            }
            
        }
        
        set(newValue) {
            userData?.setValue(newValue, forKey: "maxHp")
        }
    }
    
    var sound:AVAudioPlayer?{
        get {
            
            if let v = userData?.value(forKey: "audio") as? AVAudioPlayer{
                return v
            }
            else{
                print ("Extension SKNode Error for sound Variable: ")
                return nil
            }
            
        }
        
        set(newValue) {
            userData?.setValue(newValue, forKey: "audio")
        }
    }
    
    func run(action: SKAction, optionalCompletion: ((Void) -> Void)?){
        guard let completion = optionalCompletion else {
            run(action)
            return
        }
        
        run(SKAction.sequence([action, SKAction.run(completion)]))
        
    }
    
    
    
}

extension SKSpriteNode{
    func addHealthBar(){
        let w:CGFloat = size.width * 0.9
        let h:CGFloat = 10.0
        
        let shape = CGRect(x: 0, y: -5, width: w, height: h)
        let border = SKShapeNode(rect: shape, cornerRadius: 5)
        border.glowWidth = 1.5
        border.strokeColor = .black
        border.name = "hpBorder"
        border.lineWidth = 1.5
        
        let bar = SKSpriteNode()
        bar.anchorPoint.x = -0.01
        bar.name = "hpBar"
        bar.size = CGSize(width: w*0.98, height: h*0.8)
        bar.color = .green
        bar.zPosition = -0.1
        bar.position.x = -(bar.size.width/2)
        bar.position.y = -size.height/2 - 10
        bar.addChild(border)
        bar.isHidden = true
        
        self.addChild(bar)
    }
}


extension SKScene{
    func removeUIViews(){
            for view in (view?.subviews)! {
                view.removeFromSuperview()
            }
            
    }
    
    func recursiveRemovingSKActions(sknodes:[SKNode]){
        
        for childNode in sknodes{
            childNode.removeAllActions()
            if childNode.children.count > 0 {
                recursiveRemovingSKActions(sknodes: childNode.children)
            }
            
        }
        
    }
}

extension SKLabelNode{
    func shadowNode(nodeName:String) -> SKEffectNode{
        
        let myShader = SKShader(fileNamed: "gradientMonoTone")
        
        let effectNode = SKEffectNode()
        effectNode.shader = myShader
        effectNode.shouldEnableEffects = true
        effectNode.addChild(self)
        effectNode.name = nodeName
        return effectNode
    }
}

/*RANDOM FUNCTIONS */

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random( min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int{
    //return randomInt() * (max - min ) + min
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}
