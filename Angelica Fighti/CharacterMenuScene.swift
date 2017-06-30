//
//  CharacterMenuScene.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/2/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit

class CharacterMenuScene:SKScene{
    
    deinit{
        print("CharacterMenuScene deinitiated")
    }
    
    enum CurrToon:Int{
        case Alpha = 0
        case Beta = 1
        case Celta = 2
        case Delta = 3
    }
    
    enum Update{
        case ToonSelected
        case ToonChanged
        case UpdateTexture
    }
    
    let MAXTOONS:Int = 4
    
    fileprivate var charNode = SKSpriteNode()
    
    fileprivate var gameinfo = GameInfo()
    
    fileprivate var currToonIndex = 0
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        currToonIndex = gameinfo.getCurrentToonIndex()
        loadBackground()
        load()
        
        }
    
    private func loadBackground(){
        let bg = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_Background))
        bg.zPosition = -10
        self.addChild(bg)
    }
    
    private func load(){
        
        //GameInfo Load
        let check = gameinfo.load(scene: self)
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }else{
            // Fix Inforbar Position
            let infobar = self.childNode(withName: "infobar")!
            infobar.position.y -= screenSize.size.height/2
            infobar.position.x -= screenSize.size.width/2
        }
        
        // update index
            currToonIndex = self.gameinfo.getCurrentToonIndex()

        // Title
        let title = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_TitleMenu))
            title.position.y = screenSize.width/2*1.3
            title.size = CGSize(width: screenSize.width*0.6, height: screenSize.height*0.1)
        
        let titleLabel = SKLabelNode(fontNamed: "Family Guy")
            titleLabel.text = "EVERWING ACADEMY"
            titleLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            titleLabel.fontSize = screenSize.width/28
            title.addChild(titleLabel.shadowNode(nodeName: "titleEffectNodeLabel"))
        
        self.addChild(title)
        
        // BackArrow
        let backarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_BackArrow))
            backarrow.name = Global.Main.Character_Menu_BackArrow.rawValue
            backarrow.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            backarrow.position = CGPoint(x: -title.size.width/2 - 10, y: title.position.y + 3)
            backarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.06)
        self.addChild(backarrow)
        
        // Left Arrow
        let Larrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_LeftArrow))
            Larrow.position.x = -screenSize.width/2 * 0.8
            Larrow.position.y = 50
            Larrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.1)
            Larrow.name = Global.Main.Character_Menu_LeftArrow.rawValue
        self.addChild(Larrow)
        // Right Arrow
        let Rarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_RightArrow))
            Rarrow.position.x = screenSize.width/2 * 0.8
            Rarrow.position.y = 50
            Rarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.1)
            Rarrow.name = Global.Main.Character_Menu_RightArrow.rawValue
        self.addChild(Rarrow)
        
        
        // Character
            charNode.texture = global.getMainTexture(main: .Character_Menu_Alpha) // Default
            charNode.anchorPoint = CGPoint(x: 0.5, y: 0.3)
            charNode.size = CGSize(width: screenSize.width/1.5, height: screenSize.height/2.55)
            charNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 10, duration: 1), SKAction.moveBy(x: 0, y: -10, duration: 1.2)])))
        self.addChild(charNode)
        
        // Selected Char
        let selected = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_GlowingEffect))
            selected.name = Global.Main.Character_Menu_GlowingEffect.rawValue
            selected.position.y = -48
            selected.alpha = 0.7
        self.addChild(selected)
        
        // Ground Effect
        let gEffect = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_GroundEffect))
        let scaleY = SKAction.scaleY(to: -0.4, duration: 0)
        let scaleX = SKAction.scaleX(to: 1.8, duration: 0)
        let distort = SKAction.group([scaleX, scaleY])
            gEffect.name = Global.Main.Character_Menu_GroundEffect.rawValue
            gEffect.position.y = -130
            gEffect.run(distort)
        self.addChild(gEffect)
        
        // Message Box
        let msgBox = SKSpriteNode()
            msgBox.size = CGSize(width: screenSize.width, height: screenSize.height/4)
            msgBox.name = Global.Main.Character_Menu_MessageBox.rawValue
            msgBox.texture = global.getMainTexture(main: .Character_Menu_MessageBox)
            msgBox.position.y = -screenSize.height/2 + msgBox.size.height/2 + 10
        self.addChild(msgBox)
        
        // Character Name
        let char_name_box = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_CharacterNameBar))
            char_name_box.size = CGSize(width: screenSize.width*0.6, height: screenSize.height*0.1)
            char_name_box.name = "char_name_box"
            char_name_box.position.y = msgBox.size.height/2
            msgBox.addChild(char_name_box)
        let nameBoxLabel = SKLabelNode(fontNamed: "Cartwheel")
            nameBoxLabel.name = "nameBoxLabel"
            nameBoxLabel.text = "ALPHA"
            nameBoxLabel.fontSize = char_name_box.size.width/10
            nameBoxLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            char_name_box.addChild(nameBoxLabel.shadowNode(nodeName: "nameBoxLabel"))
        let titleBoxLabel = SKLabelNode(fontNamed: "Cartwheel")
            titleBoxLabel.name = "titleBoxLabel"
            titleBoxLabel.text = "GUARDIAN OF DRAGONS"
            titleBoxLabel.position.y -= char_name_box.size.height/4
            titleBoxLabel.fontSize = char_name_box.size.width/14
            titleBoxLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            char_name_box.addChild(titleBoxLabel.shadowNode(nodeName: "titleBoxLabel"))
        
        // MessageBox left Root
        let leftRoot = SKSpriteNode()
            leftRoot.color = .clear
            leftRoot.size = CGSize(width: msgBox.size.height/3, height: msgBox.size.height/3)
            leftRoot.position.x = -msgBox.size.width/4
            msgBox.addChild(leftRoot)
        
        // Icon Badge
        let iconBadge = SKSpriteNode()
            iconBadge.size = CGSize(width: leftRoot.size.width*0.9, height: leftRoot.size.height*0.9)
            iconBadge.texture = global.getMainTexture(main: .Character_Menu_Badge)
            leftRoot.addChild(iconBadge)
        
        // MessageBox Right Root
        let rightRoot = SKSpriteNode()
            rightRoot.color = .clear
            rightRoot.name = "character_menu_rightRoot"
            rightRoot.anchorPoint = CGPoint(x: 0, y: 0.5)
            rightRoot.size = CGSize(width: msgBox.size.width/2, height: msgBox.size.height/2)
            rightRoot.position = leftRoot.position
            rightRoot.position.x += leftRoot.size.width/2
            rightRoot.position.y -= 5
            msgBox.addChild(rightRoot)
        
        //text area of Message Box
        let txtBox = SKSpriteNode()
            txtBox.name = "character_menu_text_box"
            txtBox.size = CGSize(width: rightRoot.size.width*0.9, height: rightRoot.size.height/2)
            txtBox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            txtBox.position.x = msgBox.size.width*0.03
            txtBox.position.y = txtBox.size.height - 4
            txtBox.color = .clear
            rightRoot.addChild(txtBox)
        
        let MAGICNUMBER:CGFloat = 17
     
        // 1st Line
        let firstlinebox = SKSpriteNode()
            firstlinebox.name = "character_menu_firstlinebox"
            firstlinebox.size = CGSize(width: txtBox.size.width, height: txtBox.size.height/3)
            firstlinebox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            firstlinebox.color = .clear
            txtBox.addChild(firstlinebox)
        let firstLabel = SKLabelNode()
            firstLabel.name = "character_menu_firstlabel"
            firstLabel.horizontalAlignmentMode = .left
            firstLabel.verticalAlignmentMode = .top
            firstLabel.fontColor = .brown
            firstLabel.text = "She was born in the wilds and"
            firstLabel.fontName = "GillSans-Bold"
            firstLabel.fontSize = firstlinebox.size.width/MAGICNUMBER
            firstlinebox.addChild(firstLabel)
   
        // 2nd Line
        let secondlinebox = SKSpriteNode()
            secondlinebox.name = "character_menu_secondlinebox"
            secondlinebox.size = CGSize(width: txtBox.size.width, height: txtBox.size.height/3)
            secondlinebox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            secondlinebox.position.y = -secondlinebox.size.height
            secondlinebox.color = .clear
            txtBox.addChild(secondlinebox)
    
        let secondLabel = SKLabelNode()
            secondLabel.name = "character_menu_secondlabel"
            secondLabel.horizontalAlignmentMode = .left
            secondLabel.verticalAlignmentMode = .top
            secondLabel.fontColor = .brown
            secondLabel.text = "raised by dragons. When dragons"
            secondLabel.fontName = "GillSans-Bold"
            secondLabel.fontSize = secondlinebox.size.width/MAGICNUMBER
            secondlinebox.addChild(secondLabel)
       
        // 3rd Line
        let thirdlinebox = SKSpriteNode()
            thirdlinebox.name = "character_menu_thirdlinebox"
            thirdlinebox.size = CGSize(width: txtBox.size.width, height: txtBox.size.height/3)
            thirdlinebox.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            thirdlinebox.position.y = -2*thirdlinebox.size.height
            thirdlinebox.color = .clear
            txtBox.addChild(thirdlinebox)
       
        let thirdLabel = SKLabelNode()
            thirdLabel.name = "character_menu_thirdlabel"
            thirdLabel.horizontalAlignmentMode = .left
            thirdLabel.verticalAlignmentMode = .top
            thirdLabel.fontColor = .brown
            thirdLabel.text = "fly with her, they earn 2x XP!"
            thirdLabel.fontName = "GillSans-Bold"
            thirdLabel.fontSize = thirdlinebox.size.width/MAGICNUMBER
            thirdlinebox.addChild(thirdLabel)
        
        // Green Button
        let msgGreenButton = SKSpriteNode()
            msgGreenButton.size = CGSize(width: rightRoot.size.height, height: rightRoot.size.height/2)
            msgGreenButton.color = .clear
            msgGreenButton.name = Global.Main.Character_Menu_GreenButton.rawValue
            msgGreenButton.texture = global.getMainTexture(main: .Character_Menu_GreenButton)
            msgGreenButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            msgGreenButton.position.y = -txtBox.size.height
            msgGreenButton.position.x = rightRoot.size.width/2
            rightRoot.addChild(msgGreenButton)
        let gbuttonLabel = SKLabelNode(fontNamed: "Cartwheel")
            gbuttonLabel.position.y += msgGreenButton.size.height*0.377
            gbuttonLabel.fontSize = msgGreenButton.size.width/5
            gbuttonLabel.text = "Selected"
            msgGreenButton.addChild(gbuttonLabel)
        
        // Blue Button
        let msgBlueButton = SKSpriteNode()
            msgBlueButton.size = CGSize(width: rightRoot.size.height, height: rightRoot.size.height/2)
            msgBlueButton.color = .clear
            msgBlueButton.name = Global.Main.Character_Menu_BlueButton.rawValue
            msgBlueButton.texture = global.getMainTexture(main: .Character_Menu_BlueButton)
            msgBlueButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            msgBlueButton.position.y = -txtBox.size.height
            msgBlueButton.position.x = rightRoot.size.width/2
            msgBlueButton.isHidden = true
            rightRoot.addChild(msgBlueButton)
        let bbuttonLabel = SKLabelNode(fontNamed: "Cartwheel")
            bbuttonLabel.position.y += msgBlueButton.size.height*0.377
            bbuttonLabel.fontSize = msgBlueButton.size.width/5
            bbuttonLabel.text = "Equip"
            msgBlueButton.addChild(bbuttonLabel)
        
        update(Case: .UpdateTexture) // update toon texture
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        for touch in touches{
            pos = touch.location(in: self)
        }
        let childs = self.nodes(at: pos)
        for c in childs{
            if c.name == Global.Main.Character_Menu_BackArrow.rawValue{
                doTask(gb: .Character_Menu_BackArrow)
            }
            else if c.name == Global.Main.Character_Menu_RightArrow.rawValue{
                doTask(gb: .Character_Menu_RightArrow)
            }
            else if c.name == Global.Main.Character_Menu_LeftArrow.rawValue{
                doTask(gb: .Character_Menu_LeftArrow)
            }
            else if c.name == Global.Main.Character_Menu_BlueButton.rawValue{
                doTask(gb: .Character_Menu_BlueButton)
            }
        }
    }
    
    private func doTask(gb:Global.Main){
        switch gb {
        case .Character_Menu_BackArrow:
            
            self.gameinfo.prepareToChangeScene()
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            let newScene = MainScene(size: self.size)
            self.view?.presentScene(newScene)
        case .Character_Menu_LeftArrow:
            prevArrow(currToon: CurrToon(rawValue: currToonIndex)!)
        case .Character_Menu_RightArrow:
            nextArrow(currToon: CurrToon(rawValue: currToonIndex)!)
        case .Character_Menu_BlueButton:
            self.gameinfo.selectToonIndex(index: self.currToonIndex)
           update(Case: .ToonSelected)
            
        default:
            print("Should not reach Here - doTask from CharacterMenuScene")
        }
    }
    
    
    private func update(Case: Update){
    
        let toon = CurrToon(rawValue: currToonIndex)
        
        let msgbox = self.childNode(withName: Global.Main.Character_Menu_MessageBox.rawValue)!
        let msgboxRightRoot = msgbox.childNode(withName: "character_menu_rightRoot")!
        
        switch Case {
      
        case .ToonChanged:
            if toon!.rawValue != gameinfo.getCurrentToonIndex(){
                self.childNode(withName: Global.Main.Character_Menu_GlowingEffect.rawValue)!.isHidden = true
                self.childNode(withName: Global.Main.Character_Menu_GroundEffect.rawValue)!.isHidden = true
                
                msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_BlueButton.rawValue)!.isHidden = false
                msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_GreenButton.rawValue)!.isHidden = true
            }
            else{
                self.childNode(withName: Global.Main.Character_Menu_GlowingEffect.rawValue)!.isHidden = false
                self.childNode(withName: Global.Main.Character_Menu_GroundEffect.rawValue)!.isHidden = false
                msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_BlueButton.rawValue)!.isHidden = true
                msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_GreenButton.rawValue)!.isHidden = false
            }
            updateToonUI(toon: toon!)
      
        case .ToonSelected:
            self.childNode(withName: Global.Main.Character_Menu_GlowingEffect.rawValue)!.isHidden = false
            self.childNode(withName: Global.Main.Character_Menu_GroundEffect.rawValue)!.isHidden = false
            msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_BlueButton.rawValue)!.isHidden = true
            msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_GreenButton.rawValue)!.isHidden = false
            selectedCharAnimation()
        case .UpdateTexture:
            updateToonUI(toon: toon!)
        }
    }
    
    private func updateToonUI(toon:CurrToon){
        let msgbox = self.childNode(withName: Global.Main.Character_Menu_MessageBox.rawValue)!
        let charBoxName = msgbox.childNode(withName: "char_name_box")!
        let nameBoxLabelEffect = charBoxName.childNode(withName: "nameBoxLabel") as! SKEffectNode
        let nameBoxLabel = nameBoxLabelEffect.childNode(withName: "nameBoxLabel") as! SKLabelNode
        let titleBoxLabelEffect = charBoxName.childNode(withName: "titleBoxLabel") as! SKEffectNode
        let titleBoxLabel = titleBoxLabelEffect.childNode(withName: "titleBoxLabel") as! SKLabelNode
        let msgboxRightRoot = msgbox.childNode(withName: "character_menu_rightRoot")!
        let textbox = msgboxRightRoot.childNode(withName: "character_menu_text_box")
        let fbox = textbox?.childNode(withName: "character_menu_firstlinebox")
        let flabel = fbox?.childNode(withName: "character_menu_firstlabel") as! SKLabelNode
        let sbox = textbox?.childNode(withName: "character_menu_secondlinebox")
        let slabel = sbox?.childNode(withName: "character_menu_secondlabel") as! SKLabelNode
        let tbox = textbox?.childNode(withName: "character_menu_thirdlinebox")
        let tlabel = tbox?.childNode(withName: "character_menu_thirdlabel") as! SKLabelNode
        
        // Update Texture
        switch toon {
        case .Alpha:
            charNode.texture! = global.getMainTexture(main: .Character_Menu_Alpha)
        case .Beta:
            charNode.texture! = global.getMainTexture(main: .Character_Menu_Beta)
        case .Celta:
            charNode.texture! = global.getMainTexture(main: .Character_Menu_Celta)
        case .Delta:
            charNode.texture! = global.getMainTexture(main: .Character_Menu_Delta)
        }
        
        // Update Description
            flabel.text = self.gameinfo.getDescriptionOfToonByIndex(index: toon.rawValue)[0]
            slabel.text = self.gameinfo.getDescriptionOfToonByIndex(index: toon.rawValue)[1]
            tlabel.text = self.gameinfo.getDescriptionOfToonByIndex(index: toon.rawValue)[2]
        
        // Update Name & Title
            nameBoxLabel.text = gameinfo.getNameOfToonByIndex(index: toon.rawValue)
            titleBoxLabel.text = gameinfo.getTitleOfToonByIndex(index: toon.rawValue)
    }
    private func nextArrow(currToon:CurrToon){
        currToonIndex = currToon.rawValue + 1
        
        if (currToonIndex >= MAXTOONS){
            currToonIndex = 0
        }
        
        update(Case: .ToonChanged)
    }
    
    private func prevArrow(currToon:CurrToon){
        currToonIndex = currToon.rawValue - 1
        
        if (currToonIndex < 0){
            currToonIndex = MAXTOONS - 1
        }
        
        update(Case: .ToonChanged)
    }
    
    private func selectedCharAnimation(){
        let yPos:CGFloat = -charNode.size.height/3
        
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
        let effect1 = SKEmitterNode(fileNamed: "selectedChar-One.sks")
        effect1?.position.y = yPos
        effect1?.position.x = -50
        effect1?.run(removeChildAction)
        effect1?.zPosition = -1.0
        addChild(effect1!)
        
        let effect2 = SKEmitterNode(fileNamed: "selectedChar-One.sks")
        effect2?.position.y = yPos
        effect2?.position.x = 50
        effect2?.run(removeChildAction)
        effect2?.zPosition = -1.0
        effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
        effect2?.xAcceleration = -550
        addChild(effect2!)
        
        let effect3 = SKEmitterNode(fileNamed: "selectedChar-Two.sks")
        effect3?.position.y = yPos
        effect3?.run(removeChildAction)
        effect3?.zPosition = 0.0
        addChild(effect3!)
        
        let effect4 = SKEmitterNode(fileNamed: "selectedChar-Three.sks")
        effect4?.position.y = yPos
        effect4?.position.x = -30
        effect4?.run(removeChildAction)
        effect4?.zPosition = 1.0
        addChild(effect4!)
        
        let effect5 = SKEmitterNode(fileNamed: "selectedChar-Three.sks")
        effect5?.position.y = yPos
        effect5?.position.x = 30
        effect5?.run(removeChildAction)
        effect5?.zPosition = 1.0
        effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
        effect5?.xAcceleration = -400
        addChild(effect5!)
        
    }
    
}
