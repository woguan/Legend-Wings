//
//  BulletMaker.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 7/4/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class BulletMaker:NSObject{
    
    enum BulletType {
        case Type_1
        case Type_2
        case Type_3
        case Type_4
        case Type_5
        
    }
    enum Level: Int{
        case Level_1 = 1
        case Level_2 = 2
        case Level_3 = 3
        case Level_4 = 4
        case Level_5 = 5
        case Level_6 = 6
        case Level_7 = 7
        case Level_8 = 8
        case Level_9 = 9
        case Level_10 = 10
        case Level_11 = 11
        case Level_12 = 12
        case Level_13 = 13
        case Level_14 = 14
        case Level_15 = 15
        case Level_16 = 16
        case Level_17 = 17
        case Level_18 = 18
        case Level_19 = 19
        case Level_20 = 20
        case Level_21 = 21
        case Level_22 = 22
        case Level_23 = 23
        case Level_24 = 24
        case Level_25 = 25
        case Level_26 = 26
        case Level_27 = 27
        case Level_28 = 28
        case Level_29 = 29
        case Level_30 = 30
        case Level_31 = 31
        case Level_32 = 32
        case Level_33 = 33
        case Level_34 = 34
        case Level_35 = 35
        case Level_36 = 36
        case Level_37 = 37
        case Level_38 = 38
        case Level_39 = 39
        case Level_40 = 40
        case Level_41 = 41
        case Level_42 = 42
        case Level_43 = 43
        case Level_44 = 44
        case Level_45 = 45
        case Level_46 = 46
        case Level_47 = 47
        case Level_48 = 48
        case Level_49 = 49
        case Level_50 = 50
    }
    
    private func addBullet(sprite:SKTexture, dx: CGFloat, dy: CGFloat, zPos:CGFloat) -> SKSpriteNode{
        let node = SKSpriteNode(texture: sprite)
        node.position.x = sprite.size().width*dx
        node.position.y = sprite.size().height*dy
        node.zPosition = zPos
        node.alpha = 1.0
        
        return node
    }
    
    private func getBulletType(charType: Toon.Character, type:BulletType) -> SKTexture{
        
        switch charType {
        case .Alpha:
            switch type {
            case .Type_1:
                return global.getMainTexture(main: .Character_Alpha_Projectile_1)
            case .Type_2:
                return global.getMainTexture(main: .Character_Alpha_Projectile_2)
            case .Type_3:
                return global.getMainTexture(main: .Character_Alpha_Projectile_3)
            case .Type_4:
                return global.getMainTexture(main: .Character_Alpha_Projectile_4)
            case .Type_5:
                return global.getMainTexture(main: .Character_Alpha_Projectile_5)
            }
        case .Beta:
            switch type {
            case .Type_1:
                return global.getMainTexture(main: .Character_Beta_Projectile_1)
            case .Type_2:
                return global.getMainTexture(main: .Character_Beta_Projectile_2)
            case .Type_3:
                return global.getMainTexture(main: .Character_Beta_Projectile_3)
            case .Type_4:
                return global.getMainTexture(main: .Character_Beta_Projectile_4)
            case .Type_5:
                return global.getMainTexture(main: .Character_Beta_Projectile_5)
            }
        case .Celta:
            switch type {
            case .Type_1:
                return global.getMainTexture(main: .Character_Celta_Projectile_1)
            case .Type_2:
                return global.getMainTexture(main: .Character_Celta_Projectile_2)
            case .Type_3:
                return global.getMainTexture(main: .Character_Celta_Projectile_3)
            case .Type_4:
                return global.getMainTexture(main: .Character_Celta_Projectile_4)
            case .Type_5:
                return global.getMainTexture(main: .Character_Celta_Projectile_5)
            }
        case .Delta:
            switch type {
            case .Type_1:
                return global.getMainTexture(main: .Character_Delta_Projectile_1)
            case .Type_2:
                return global.getMainTexture(main: .Character_Delta_Projectile_2)
            case .Type_3:
                return global.getMainTexture(main: .Character_Delta_Projectile_3)
            case .Type_4:
                return global.getMainTexture(main: .Character_Delta_Projectile_4)
            case .Type_5:
                return global.getMainTexture(main: .Character_Delta_Projectile_5)
            }
        default:
            switch type {
            case .Type_1:
                return global.getMainTexture(main: .Character_Alpha_Projectile_1)
            case .Type_2:
                return global.getMainTexture(main: .Character_Alpha_Projectile_2)
            case .Type_3:
                return global.getMainTexture(main: .Character_Alpha_Projectile_3)
            case .Type_4:
                return global.getMainTexture(main: .Character_Alpha_Projectile_4)
            case .Type_5:
                return global.getMainTexture(main: .Character_Alpha_Projectile_5)
            }
            // case .Celta:
            // case .Delta:
        }
    }
    
    internal func make(level:Level, char:Toon.Character) -> SKSpriteNode{
        let node = SKSpriteNode()
        
        let s1 = getBulletType(charType: char, type: .Type_1)
        let s2 = getBulletType(charType: char, type: .Type_2)
        let s3 = getBulletType(charType: char, type: .Type_3)
        let s4 = getBulletType(charType: char, type: .Type_4)
        let s5 = getBulletType(charType: char, type: .Type_5)
        
        node.name = "mainNode"
        
        switch level {
        case .Level_1:
            node.addChild(addBullet(sprite: s1, dx: 0, dy: 1/2, zPos: 1))
        case .Level_2:
            node.addChild(addBullet(sprite: s1, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1/2, dy: 1/2, zPos: 2))
        case .Level_3:
            node.addChild(addBullet(sprite: s1, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1, dy: 0, zPos: 2))
        case .Level_4:
            node.addChild(addBullet(sprite: s1, dx: -1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: 1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 2))
        case .Level_5:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
        case .Level_6:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1, dy: 0, zPos: 2))
        case .Level_7:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -2, dy: -1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 2, dy: -1/2, zPos: 2))
        case .Level_8:
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 1))
        case .Level_9:
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 2))
        case .Level_10:
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -1/2, zPos: 3))
        case .Level_11:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.75, dy: 0, zPos: 2))
        case .Level_12:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -2, dy: -1, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 2, dy: -1, zPos: 3))
        case .Level_13:
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -2, dy: -1, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 2, dy: -1, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -0.75, zPos: 4))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -0.75, zPos: 4))
        case .Level_14:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
        case .Level_15:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.25, dy: 0, zPos: 2))
        case .Level_16:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -1/2, zPos: 3))
        case .Level_17:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.75, dy: 0, zPos: 2))
        case .Level_18:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: -0.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: 0.5, dy: -1/2, zPos: 3))
        case .Level_19:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -2.0, dy: -1, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 2.0, dy: -1, zPos: 3))
        case .Level_20:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -0.5, dy: 0.25, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.5, dy: 0.25, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.0, dy: -0.25, zPos: 3))
        case .Level_21:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
        case .Level_22:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.75, dy: 0, zPos: 2))
        case .Level_23:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.75, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -0.5, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -0.5, zPos: 3))
        case .Level_24:
            node.addChild(addBullet(sprite: s3, dx: -1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 1/2, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 0, zPos: 2))
        case .Level_25:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1.25, dy: 0, zPos: 2))
        case .Level_26:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -1/2, zPos: 2))
        case .Level_27:
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: -0.25, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: 0.25, dy: -1/2, zPos: 3))
        case .Level_28:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.5, dy: 0, zPos: 2))
        case .Level_29:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -0.5, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -0.5, zPos: 3))
        case .Level_30:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -0.5, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -0.5, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: -0.25, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: -0.25, zPos: 3))
        case .Level_31:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: -0.25, zPos: 3))
        case .Level_32:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: -0.25, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -1, dy: 0.0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1, dy: 0.0, zPos: 3))
        case .Level_33:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: -0.25, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -1, dy: 0.0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1, dy: 0.0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -0.75, dy: -0.25, zPos: 4))
            node.addChild(addBullet(sprite: s1, dx: 0.75, dy: -0.25, zPos: 4))
        case .Level_34:
            node.addChild(addBullet(sprite: s3, dx: 0, dy: 1/2, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0, dy: -0.25, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: -1, dy: 0.0, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: 1, dy: 0.0, zPos: 3))
        case .Level_35:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
        case .Level_36:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1/2, dy: 1/2, zPos: 2))
        //node.addChild(make(level: .Level_2, char: char))
        case .Level_37:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s1, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 3))
        case .Level_38:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 2))
        case .Level_39:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 3))
        case .Level_40:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -0.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 0.5, dy: -1/2, zPos: 3))
        case .Level_41:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s2, dx: -1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1/2, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: -1.25, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: 1.25, dy: 0, zPos: 3))
        case .Level_42:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
        case .Level_43:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 3))
        case .Level_44:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s1, dx: 1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -1.5, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: 2.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s1, dx: -2.5, dy: -1/2, zPos: 3))
        case .Level_45:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 1.0, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: -1.0, dy: 0, zPos: 3))
        case .Level_46:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.0, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: -0.5, dy: 0, zPos: 2))
            node.addChild(addBullet(sprite: s2, dx: 0.5, dy: -1/2, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: -0.5, dy: -1/2, zPos: 3))
        case .Level_47:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.75, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s3, dx: -0.75, dy: 0, zPos: 3))
        case .Level_48:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.75, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s3, dx: -0.75, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s2, dx: 0.5, dy: -1/2, zPos: 4))
            node.addChild(addBullet(sprite: s2, dx: -0.5, dy: -1/2, zPos: 4))
        case .Level_49:
            node.addChild(addBullet(sprite: s4, dx: 0, dy: 0, zPos: 1))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: 1/2, zPos: 2))
            node.addChild(addBullet(sprite: s3, dx: 0.75, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s3, dx: -0.75, dy: 0, zPos: 3))
            node.addChild(addBullet(sprite: s3, dx: 0.25, dy: -1/2, zPos: 4))
            node.addChild(addBullet(sprite: s3, dx: -0.25, dy: -1/2, zPos: 4))
        case .Level_50:
            node.addChild(addBullet(sprite: s5, dx: 0, dy: 0, zPos: 1))
        }
        return node
    }
}
    
