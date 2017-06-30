//
//  Infobar.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/30/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import SpriteKit

class Infobar:SKSpriteNode{
    
    
    private let enableDebug:Bool = false
    
    private let mainRootWidth:CGFloat = screenSize.width
    private let mainRootHeight:CGFloat = 100
    private var firstTemplate:SKSpriteNode!
    private var secondTemplate:SKSpriteNode!
    private var thirdTemplate:SKSpriteNode!
    private var fourthTemplate:SKSpriteNode!
    
    
    convenience init(name n:String){
        self.init()
        
        let rootItemSize:CGSize = CGSize(width: screenSize.width/4, height: screenSize.height*0.05)
        
        name = n
        color = .clear
        
        size = CGSize(width: mainRootWidth, height: mainRootHeight)
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: screenSize.height - mainRootHeight)
        
        firstTemplate = template(itemSize: rootItemSize, name: "topbar_first_item", barSprite:.Main_Menu_Level_Bar, iconSprite: .Main_Menu_Level_Badge, previousPos: nil)
        secondTemplate = template(itemSize: rootItemSize, name: "topbar_second_item", barSprite:.Main_Menu_Currency_Bar, iconSprite: .Main_Menu_Coin, previousPos: firstTemplate.position)
        thirdTemplate = template(itemSize: rootItemSize, name: "topbar_third_item", barSprite:.Main_Menu_Currency_Bar, iconSprite: .Main_Menu_Trophy, previousPos: secondTemplate.position)
        fourthTemplate = customFourthLabel(itemSize: rootItemSize, prevNodePosition: thirdTemplate.position)
        
        
        // adding first
        addChild(firstTemplate)
        
        // adding second
        addChild(secondTemplate)
        
        // adding third
        addChild(thirdTemplate)
        
        // adding fourth
        addChild(fourthTemplate)
        
        // Note: It will execute only if debug is enabled
        debug()
        
        
    }
    
    private func getRootModelNode(width w:CGFloat, height h:CGFloat, dx:CGFloat, name n:String) -> SKSpriteNode{
        
        let node = SKSpriteNode()
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.color = .clear
        node.name = n
        node.size = CGSize(width: w, height: h)
        node.position = CGPoint(x: dx, y: mainRootHeight - h)
        
        return node
    }
    
    private func fillNode(node:SKSpriteNode, barName:String, barSprite: Global.Main, iconName:String, iconSprite: Global.Main){
        
        // Bar
        let bar = SKSpriteNode()
        let barWidth:CGFloat = node.size.width*0.8
        let barHeight:CGFloat = node.size.height*0.8
        let barXpos:CGFloat = node.size.width
        let barYpos:CGFloat = 0
        
        bar.anchorPoint = CGPoint(x: 1, y: 0)
        bar.name = barName
        bar.size = CGSize(width: barWidth, height: barHeight)
        bar.texture = global.getMainTexture(main: barSprite)
        bar.position = CGPoint(x: barXpos, y: barYpos)
        node.addChild(bar)
        
        // Testing add labels here
        
        // icon
        let icon = SKSpriteNode()
        let iconWidth:CGFloat = node.size.height * 0.94
        let iconHeight:CGFloat = node.size.height * 0.94
        let iconXpos:CGFloat = node.size.width - bar.size.width
        let iconYpos:CGFloat = 0
        
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        icon.zPosition = 1
        icon.name = iconName
        icon.size = CGSize(width: iconWidth, height: iconHeight)
        icon.position = CGPoint(x: iconXpos, y: iconYpos)
        icon.texture = global.getMainTexture(main: iconSprite)
        node.addChild(icon)
    }
    private func template(itemSize: CGSize, name n:String, barSprite: Global.Main, iconSprite: Global.Main, previousPos prev:CGPoint?) -> SKSpriteNode{
        
        var px:CGFloat!
        
        let (w, h) = (itemSize.width, itemSize.height)
        
        px = (prev == nil) ? 0.0 : prev!.x + w
        
        let node = getRootModelNode(width: w, height: h, dx: px,  name: n)
        
        fillNode(node: node, barName: barSprite.rawValue, barSprite: barSprite, iconName: iconSprite.rawValue, iconSprite: iconSprite)
        
        return node
    }
    
    // fourth item
    private func customFourthLabel(itemSize:CGSize, prevNodePosition prev:CGPoint) -> SKSpriteNode{
        
        let width = itemSize.width
        let height = itemSize.height
        let node = getRootModelNode(width: width, height: height, dx: prev.x + itemSize.width, name: "topbar_right_corner")
        node.position.y += 100 // decrease 100 to show to user
        
        // gold
        let curr = Currency(type: .Coin)
        let coinWidth:CGFloat = height*0.9
        let coinHeight:CGFloat = height*0.9
        let coinXpos:CGFloat = width - coinWidth/2
        let coinYpos:CGFloat = coinHeight/2 //+ 100 // decrease 50 to show on screen
        
        
        let goldIcon = curr.createCoin(posX: coinXpos, posY: coinYpos, width: coinWidth, height: coinHeight, createPhysicalBody: false, animation: true)
        
        
        goldIcon.name = "top_coin_tracker"
        node.addChild(goldIcon)
        
        // text
        let labelXPos:CGFloat = goldIcon.position.x - coinWidth/2 - (coinWidth*0.1)
        let labelYpos:CGFloat = goldIcon.position.y/2 - 2
        let labelText = SKLabelNode(fontNamed: "Cartwheel")
        labelText.text = "0"
        labelText.fontSize = 26
        labelText.fontColor = SKColor(red: 253/255, green: 188/255, blue: 0/255, alpha: 1)
        labelText.horizontalAlignmentMode = .right
        labelText.position = CGPoint(x: labelXPos, y:labelYpos)
        labelText.name = "coinText"
        node.addChild(labelText.shadowNode(nodeName: "coinLabelName"))
        
        
        node.alpha = 0.0
        return node
    }
    
    
    internal func updateGoldLabel(coinCount:Int){
        
        guard let coinShadowLabel = fourthTemplate.childNode(withName: "coinLabelName") as? SKEffectNode else{
            print ("ERROR A01: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "coinText") as? SKLabelNode else{
            print ("ERROR A02: Check updateGoldLabel method from Class Infobar")
            return
        }
        
        coinLabel.text = String(coinCount)
    }
    
    internal func fadeAway(){
        
        let fadeAwayAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
        
        let showCoinLabelAction = SKAction.group([SKAction.moveBy(x: 0, y: -100, duration: 0.3), SKAction.fadeAlpha(to: 1.0, duration: 0.3)])
        
        firstTemplate.run(fadeAwayAction)
        secondTemplate.run(fadeAwayAction)
        thirdTemplate.run(fadeAwayAction)
        fourthTemplate.run(showCoinLabelAction)
    }
    
    
    private func debug(){
        if !enableDebug{
            return
        }
        
        self.color = .red
        firstTemplate.color = .yellow
        secondTemplate.color = .blue
        thirdTemplate.color = .brown
        fourthTemplate.color = .purple
        
        return
    }
}

