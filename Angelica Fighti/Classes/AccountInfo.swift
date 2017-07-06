//
//  AccountInfo.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/3/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit

class AccountInfo{
    
    deinit{
        print("AccountInfo Deinitiated")
    }
    
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    
    // For future update
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
        characters = [Toon(char: .Alpha), Toon(char: .Beta), Toon(char: .Celta), Toon(char: .Delta)]
        highscore = 0
        
    }
    
    func load() -> Bool{
        
        let plist = NSDictionary(contentsOfFile: documentDir.appendingPathComponent("userinfo.plist"))
        
        // Update Root
            level = plist?.value(forKey: "Level") as! Int
            gold = plist?.value(forKey: "Coin") as! Int
            experience = plist?.value(forKey: "Experience") as! CGFloat
            highscore = plist?.value(forKey: "Highscore") as! Int
            currentToonIndex = plist?.value(forKey: "CurrentToon") as! Int
        
        let toondDict = plist?.value(forKey: "Toons") as! NSDictionary
        
            characters[0].load(infoDict: toondDict.value(forKey: "Alpha") as! NSDictionary)
            characters[1].load(infoDict: toondDict.value(forKey: "Beta") as! NSDictionary)
            characters[2].load(infoDict: toondDict.value(forKey: "Celta") as! NSDictionary)
            characters[3].load(infoDict: toondDict.value(forKey: "Delta") as! NSDictionary)
        
        return true
    }
    
    internal func getGoldBalance() -> Int{
        return self.gold
    }
    
    internal func getCurrentToon() -> Toon{
        return characters[currentToonIndex]
    }
    
    internal func getCurrentToonIndex() -> Int{
        return currentToonIndex
    }
    
    internal func selectToonIndex(index: Int){
        
        let fullPath = documentDir.appendingPathComponent("userinfo.plist")
        let plist = NSMutableDictionary(contentsOfFile: fullPath)
        
            currentToonIndex = index
            plist!.setValue(index, forKey: "CurrentToon")

        if !plist!.write(toFile: fullPath, atomically: false){
            print("Saving Error - AccountInfo.selectToonIndex")
        }
    }
    
    internal func getToonDescriptionByIndex(index: Int) -> [String]{
        return characters[index].getToonDescription()
    }
    internal func getNameOfToonByIndex(index: Int) -> String{
        return characters[index].getToonName()
    }
    internal func getTitleOfToonByIndex(index: Int) -> String{
        return characters[index].getToonTitle()
    }
    internal func getBulletLevelOfToonByIndex(index: Int) -> Int{
        return characters[index].getBulletLevel()
    }
    internal func prepareToChangeScene(){
        characters.removeAll()
    }
    
}
