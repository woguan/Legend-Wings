//
//  AccountInfo.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 1/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit


struct AccountInfo{
    
   /* struct Bag{
        var something:Int
        
        init(){
            something = 0
        }
    }*/
    
    private var level:Int
    private var currentToonIndex:Int
    private var characters:[Toon]
    private var gold:Int
    private var experience:CGFloat
    private var highscore:Int
  //  var inventory:Bag
    
    init(){
        level = 0
        currentToonIndex = 0
     //   inventory = Bag()
        gold = 0
        experience = 0.0
        characters = [Toon(w: 180, h: 130)]
        highscore = 0
        
        
    }
    
    func load() -> Bool{
        characters[0].load()
     /*
        let pathToUserDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let fullPathName = pathToUserDirectory.appendingPathComponent("userinfo.plist")
        
        guard let plist = NSDictionary(contentsOfFile: fullPathName) else{
            print ("ERROR000: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let c = plist.value(forKey: "Coin") as? Int else{
            print ("ERROR001: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let ct = plist.value(forKey: "CurrentToon") as? Int else{
            print ("ERROR002: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let exp = plist.value(forKey: "Experience") as? CGFloat else{
            print ("ERROR003: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let lv = plist.value(forKey: "Level") as? Int else{
            print ("ERROR004: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let hs = plist.value(forKey: "Highscore") as? Int else{
            print ("ERROR005: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        guard let toons = plist.value(forKey: "Toons") as? [Toon] else{
            print ("ERROR006: Class AccountInfo - Method Load - Has problem")
            return false
        }
        
        self.level = lv
        self.currentToonIndex = ct
        self.gold = c
        self.experience = exp
        self.highscore = hs
        
        if (toons.count > 0){
            self.characters = toons
        }*/
        
        return true
    }
    
    
    func getCurrentToon() -> Toon{
        return characters[currentToonIndex]
    }
    
    
    
    
    
}
