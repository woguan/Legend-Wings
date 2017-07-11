//
//  Infobar.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/30/17.
//  Copyright © 2017 Wong. All rights reserved.
//
import SpriteKit

class Infobar:SKSpriteNode{
    deinit{
        print("infobar deinit")
    }
    private enum Template{
        case First // Display Level&Exp
        case Second // Display account's money
        case Third // Display trophy currency
        case Fourth // For settings - Not implemented yet
        case Fifth // Above the 'Fourth' Label. Visible once game state == .Start
    }
    
    private let enableDebug:Bool = false
    private let mainRootWidth:CGFloat = screenSize.width
    private let mainRootHeight:CGFloat = 100
    private var firstTemplate:SKSpriteNode!
    private var secondTemplate:SKSpriteNode!
    private var thirdTemplate:SKSpriteNode!
    private var fourthTemplate:SKSpriteNode!
    private var fifthTemplate:SKSpriteNode!
    
    convenience init(name n:String){
        self.init()
        
        let rootItemSize:CGSize = CGSize(width: screenSize.width/4, height: screenSize.height*0.05)
        
        name = n
        color = .clear
        
        size = CGSize(width: mainRootWidth, height: mainRootHeight)
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: screenSize.height - mainRootHeight)
       // Main_Menu_Currency_Bar
        firstTemplate = generateTemplate(templateStyle: .First, itemSize: rootItemSize, name: "topbar_first_item", barSprite:.Main_Menu_Level_Bar, iconSprite: .Main_Menu_Level_Badge, previousPos: nil)
        secondTemplate = generateTemplate(templateStyle: .Second, itemSize: rootItemSize, name: "topbar_second_item", barSprite: nil, iconSprite: .Main_Menu_Coin, previousPos: firstTemplate.position)
        thirdTemplate = generateTemplate(templateStyle: .Third, itemSize: rootItemSize, name: "topbar_third_item", barSprite: nil, iconSprite: .Main_Menu_Trophy, previousPos: secondTemplate.position)
        fourthTemplate = generateTemplate(templateStyle: .Fourth, itemSize: rootItemSize, name: "topbar_fourth_item", barSprite: nil, iconSprite: .Main_Menu_Trophy, previousPos: thirdTemplate.position)
        
        fifthTemplate = customFifthLabel(itemSize: rootItemSize, prevNodePosition: thirdTemplate.position)
        
        
        addChild(firstTemplate)
        addChild(secondTemplate)
        addChild(thirdTemplate)
        addChild(fourthTemplate)
        addChild(fifthTemplate)
        
        // Note: It will show debug view only if debug is enabled.
        debug()
        
        
    }
    
    private func makeTemplateNode(width w:CGFloat, height h:CGFloat, dx:CGFloat, name n:String) -> SKSpriteNode{
        
        let node = SKSpriteNode()
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.color = .clear
        node.name = n
        node.size = CGSize(width: w, height: h)
        node.position = CGPoint(x: dx, y: self.size.height - h)
        
        return node
    }
    

    private func generateTemplate(templateStyle:Template, itemSize: CGSize, name n:String, barSprite: Global.Main?, iconSprite: Global.Main, previousPos prev:CGPoint?) -> SKSpriteNode{
        
        var px:CGFloat!
        
        let (w, h) = (itemSize.width, itemSize.height)
        
        px = (prev == nil) ? 0.0 : prev!.x + w
        
        let node = makeTemplateNode(width: w, height: h, dx: px,  name: n)
        
        // Filling the template -->
        
        // Bar Default Values
        let barWidth:CGFloat = node.size.width*0.8
        let barHeight:CGFloat = node.size.height*0.55
        let barXpos:CGFloat = node.size.width
        let barYpos:CGFloat = 0
        
        // Icon Default Values
        let icon = SKSpriteNode()
        let iconWidth:CGFloat = node.size.height * 0.94
        let iconHeight:CGFloat = node.size.height * 0.94
        let iconXpos:CGFloat = node.size.width -  barWidth
        let iconYpos:CGFloat = -3
        
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        icon.zPosition = 1
        icon.name = iconSprite.rawValue
        icon.size = CGSize(width: iconWidth, height: iconHeight)
        icon.position = CGPoint(x: iconXpos, y: iconYpos)
        icon.texture = global.getMainTexture(main: iconSprite)
        node.addChild(icon)
        
        // icon position might be changed with the if condition below:
        
        if templateStyle == .First{
            
            let newWidth:CGFloat = node.size.width*0.5
            let newHeight:CGFloat = node.size.height*0.65
            
            let bar = SKSpriteNode()
            bar.anchorPoint = CGPoint(x: 1.0, y: 0)
            bar.name = "bar"
            bar.size = CGSize(width: newWidth, height: newHeight)
            bar.texture = global.getMainTexture(main: barSprite!)
            bar.position = CGPoint(x: barXpos*0.8, y: barYpos)
            node.addChild(bar)
            
            // Adjusting Icon
            icon.position.x = node.size.width - newWidth - barXpos*0.2
            icon.position.y = 0
        }
        else if templateStyle == .Second || templateStyle == .Third{
            let rect = CGRect(x: self.size.width*0.038, y: 0, width: barWidth, height: barHeight)
            let bar = SKShapeNode(rect: rect, cornerRadius: screenSize.height * 0.01)
            bar.alpha = 0.65
            bar.fillColor = .black
            bar.strokeColor = .black
            bar.name = "bar"
            node.addChild(bar)
            
            let label = SKLabelNode(fontNamed: "CartWheel")
            label.zPosition = 1
            label.fontSize = barWidth/5
            label.horizontalAlignmentMode = .right
            label.verticalAlignmentMode = .center
            label.position.x += node.size.width * 0.9
            label.position.y += barHeight/2.8
            label.name = "label"
            
            if templateStyle == .Second{
                label.text = "123"
                label.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
                bar.addChild(label.shadowNode(nodeName: "labelCoinEffect"))
            }
            else{
                label.text = "0"
                label.fontColor = .green
               bar.addChild(label.shadowNode(nodeName: "labelTrophyEffect"))
            }
            
        }
        else if templateStyle == .Fourth{
            // This place will be the settings. Still not available
            icon.isHidden = true
        }
        
        return node
    }
    
    // fourth item
    private func customFifthLabel(itemSize:CGSize, prevNodePosition prev:CGPoint) -> SKSpriteNode{
        
        let width = itemSize.width
        let height = itemSize.height
        let node = makeTemplateNode(width: width, height: height, dx: prev.x + itemSize.width, name: "topbar_right_corner")
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
        
        guard let coinShadowLabel = fifthTemplate.childNode(withName: "coinLabelName") as? SKEffectNode else{
            print ("ERROR A01: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "coinText") as? SKLabelNode else{
            print ("ERROR A02: Check updateGoldLabel method from Class Infobar")
            return
        }
        
        coinLabel.text = numberToString(num: coinCount)
    }
    
    internal func updateGoldBalnceLabel(balance:Int){

        
        guard let coinBarLabel = secondTemplate.childNode(withName: "bar") else{
            print ("ERROR A00: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinShadowLabel = coinBarLabel.childNode(withName: "labelCoinEffect") as? SKEffectNode else{
            print ("ERROR A01: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "label") as? SKLabelNode else{
            print ("ERROR A02: Check updateGoldLabel method from Class Infobar")
            return
        }

        coinLabel.text = numberToString(num: balance)
    }
    
    internal func fadeAway(){
        
        let fadeAwayAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
        
        let showCoinLabelAction = SKAction.group([SKAction.moveBy(x: 0, y: -100, duration: 0.3), SKAction.fadeAlpha(to: 1.0, duration: 0.3)])
        
        firstTemplate.run(fadeAwayAction)
        secondTemplate.run(fadeAwayAction)
        thirdTemplate.run(fadeAwayAction)
        fourthTemplate.run(fadeAwayAction)
        fifthTemplate.run(showCoinLabelAction)
    }
    
    
    private func numberToString(num:Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: num as NSNumber)!
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
        fifthTemplate.color = .black
        
        return
    }
}
