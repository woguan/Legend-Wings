//
//  HUD.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 5/16/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit

struct HUD{
    
    enum TextType {
        case Gold
        case Trophy
    }
    
    private var width:CGFloat
    private var height:CGFloat
    private var pos:CGPoint
    private var textType:TextType
    private var validChar:Array = Array(0..<10).map { (i) -> Character in
        return Character(String(i))
    }
    
    init(width w:CGFloat, height h:CGFloat, position p:CGPoint, type:TextType){
        width = w*0.9
        height = h*0.9
        pos = p
        textType = type
        validChar.append(Character(String(",")))
    }
    
    func getNode(text:String) -> SKSpriteNode?{
        
        if !isValidString(text){
            return nil
        }
        
        
        let node = SKSpriteNode()
        node.size = CGSize(width: width, height: height)
        node.position = pos
       // node.color = UIColor.black
        let textures = getTextures(text)
        
        var xTrack:CGFloat = 0.0
        
        for (i, t) in textures.enumerated(){
            
            if i == 0 {
                xTrack = 0
            }
            let hudtexture = SKSpriteNode()
            hudtexture.texture = t
            hudtexture.size = CGSize(width: t.size().width, height: height)
            let tw = hudtexture.size.width
            let th = hudtexture.size.height
            hudtexture.position = CGPoint(x: width/2 - tw*0.5 - xTrack, y: height/2 - th/2.0)
            node.addChild(hudtexture)
            xTrack += tw*0.8
        }
        
        return node
    }
    
    func isValidString(_ str:String) -> Bool{
        for c in str.characters{
            if !validChar.contains(c){
                print("\(str): IT IS INVALID")
                return false
            }
        }
        return true
    }
    
    func getTextures(_ text:String) -> [SKTexture]{
        var pack:[SKTexture] = []
        for c in text.characters.reversed(){
            pack.append(global.getHUDTexture(hudType: .Gold, text: String(c)))
        }
        return pack
    }
    
    func stringParser(_ str:String){
        for c in str.characters.reversed(){
            print(c)
        }
        
        
       // print("\(str): IT IS VALID")
    }
    
    
    
}
