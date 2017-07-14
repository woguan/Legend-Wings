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
    
    private enum CurrToon:Int{
        case Alpha = 0
        case Beta = 1
        case Celta = 2
        case Delta = 3
        
        var string:String{
            let name = String(describing: self)
            return name.uppercased()
        }
    }
    
    private enum Update{
        case ToonSelected
        case ToonChanged
        case UpdateTexture
        case UpgradedBullet
    }
    
    private enum State{
        case Select
        case Upgrade
    }
    
    let MAXTOONS:Int = 4
    
    fileprivate var charNode = SKSpriteNode()
    fileprivate var gameinfo = GameInfo()
    fileprivate var currToonIndex = 0
    fileprivate let bulletMaker = BulletMaker()
    private var state:State = .Select
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        currToonIndex = gameinfo.requestCurrentToonIndex()
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
            currToonIndex = self.gameinfo.requestCurrentToonIndex()

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
            leftRoot.name = "leftRoot"
            leftRoot.size = CGSize(width: msgBox.size.height/3, height: msgBox.size.height/3)
            leftRoot.position.x = -msgBox.size.width/4
            msgBox.addChild(leftRoot)
        
        // Icon Badge
        let iconBadge = SKSpriteNode()
            iconBadge.name = "iconBadge"
            iconBadge.size = CGSize(width: leftRoot.size.width*0.9, height: leftRoot.size.height*0.9)
            iconBadge.texture = global.getMainTexture(main: .Character_Menu_Badge)
            leftRoot.addChild(iconBadge)
        
        // Projectile Sprite
        let projectile = bulletMaker.make(level: .Level_1, char: .Alpha)
            projectile.name = "projectile"
            projectile.setScale(0.5)
            iconBadge.addChild(projectile)
        
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
            gbuttonLabel.name = "label"
            gbuttonLabel.position.y += msgGreenButton.size.height*0.377
            gbuttonLabel.fontSize = msgGreenButton.size.width/5
            gbuttonLabel.text = "UPDATE"
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
        
        switch state {
        case .Select:
            for c in nodes(at: pos){
                if c.name == "pause"{
                    return
                }
                else if c.name == Global.Main.Character_Menu_BackArrow.rawValue{
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
                   // self.customPause(timeInterval: 2.0)
                    let delay = SKSpriteNode()
                    delay.size = self.size
                    delay.color = .black
                    delay.alpha = 0.0
                    delay.zPosition = 15.0
                    delay.name = "pause"
                    let fadein = SKAction.fadeAlpha(to: 0.7, duration: 1.3)
                    let fadeout = SKAction.fadeAlpha(to: 0.0, duration: 0.7)
                    delay.run(SKAction.sequence([fadein, fadeout]))
                    self.addChild(delay)
                    run(SKAction.sequence([SKAction.wait(forDuration: 2.0)]), completion: delay.removeFromParent)
                }
                else if c.name == Global.Main.Character_Menu_GreenButton.rawValue{
                    doTask(gb: .Character_Menu_GreenButton)
                }
            }
        case .Upgrade:
            for c in nodes(at: pos){
                if c.name == Global.Main.Character_Menu_UpgradeCloseButton.rawValue{
                    doTask(gb: .Character_Menu_UpgradeCloseButton)
                }
                else if c.name == Global.Main.Character_Menu_UpgradeGreenButton.rawValue{
                    doTask(gb: .Character_Menu_UpgradeGreenButton)
                }
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
           update(Case: .ToonSelected)
        case .Character_Menu_GreenButton:
            self.state = showUpgrade() ? .Upgrade : .Select
        case .Character_Menu_UpgradeCloseButton:
            closeUpgrade()
        case .Character_Menu_UpgradeGreenButton:
            let (success, msg) = gameinfo.requestUpgradeBullet()
            if !success{
                print(msg)
                break
            }
            self.update(Case: .UpgradedBullet)
            if gameinfo.requestToonBulletLevel(index: currToonIndex) >= 50{
                closeUpgrade()
            }
        default:
            print("Should not reach Here - doTask from CharacterMenuScene")
        }
    }
    
    
    private func update(Case: Update){
    
        let toon = CurrToon(rawValue: currToonIndex)
        let msgbox = self.childNode(withName: Global.Main.Character_Menu_MessageBox.rawValue)!
        let msgboxRightRoot = msgbox.childNode(withName: "character_menu_rightRoot")!
        let blueButton = msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_BlueButton.rawValue)!
        let greenButton = msgboxRightRoot.childNode(withName: Global.Main.Character_Menu_GreenButton.rawValue)!
        let groundEffect = self.childNode(withName: Global.Main.Character_Menu_GroundEffect.rawValue)!
        let glowingEffect = self.childNode(withName: Global.Main.Character_Menu_GlowingEffect.rawValue)!
        let greenButtonLabel = greenButton.childNode(withName: "label") as! SKLabelNode
        
        switch Case {
      
        case .ToonChanged:
            
            if toon!.rawValue != gameinfo.requestCurrentToonIndex(){
                glowingEffect.isHidden = true
                groundEffect.isHidden = true
                blueButton.isHidden = false
                greenButton.isHidden = true
            }
            else{
                glowingEffect.isHidden = false
                groundEffect.isHidden = false
                blueButton.isHidden = true
                greenButton.isHidden = false
            }
            updateToonUI(toon: toon!)
      
        case .ToonSelected:
            self.gameinfo.requestChangeToon(index: self.currToonIndex)
            glowingEffect.isHidden = false
            groundEffect.isHidden = false
            blueButton.isHidden = true
            greenButton.isHidden = false
            selectedCharAnimation()
        case .UpdateTexture:
            updateToonUI(toon: toon!)
        case .UpgradedBullet:
            updateUpgradeScene()
            updateToonUI(toon: toon!)
        }
        
        greenButtonLabel.text = (gameinfo.requestToonBulletLevel(index: currToonIndex) >= 50) ? "MAX" : "UPDATE"
    }
    
    private func updateToonUI(toon:CurrToon){
        let msgbox = self.childNode(withName: Global.Main.Character_Menu_MessageBox.rawValue)!
        let leftRoot = msgbox.childNode(withName: "leftRoot")!
        let icon = leftRoot.childNode(withName: "iconBadge")!
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
            flabel.text = self.gameinfo.requestToonDescription(index: toon.rawValue)[0]
            slabel.text = self.gameinfo.requestToonDescription(index: toon.rawValue)[1]
            tlabel.text = self.gameinfo.requestToonDescription(index: toon.rawValue)[2]
        
        // Update Name & Title
            nameBoxLabel.text = gameinfo.requestToonName(index: toon.rawValue)
            titleBoxLabel.text = gameinfo.requestToonTitle(index: toon.rawValue)
        
        // Update Projectile (Bullet)
        let bulletLevel = gameinfo.requestToonBulletLevel(index: toon.rawValue)
        guard let currToon = Toon.Character(rawValue: toon.string),
              let blevel = BulletMaker.Level(rawValue: bulletLevel)
        else{
            return
        }
        
        if let bullet = icon.childNode(withName: "projectile"){
        bullet.removeFromParent()
        }
        let newBullet = bulletMaker.make(level: blevel, char: currToon)
        newBullet.name = "projectile"
        newBullet.setScale(0.5)
        icon.addChild(newBullet)
        
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
    
    private func showUpgrade() -> Bool{
        
        let toonLevel = gameinfo.requestToonBulletLevel(index: currToonIndex)
        let nextBulletLevel = gameinfo.requestToonBulletLevel(index: self.currToonIndex) + 1
        let currCharStr = CharacterMenuScene.CurrToon(rawValue: self.currToonIndex)!.string
        
        guard let currToon = Toon.Character(rawValue: currCharStr),
            let blevel = BulletMaker.Level(rawValue: nextBulletLevel)
            else{
                return false
            }
        
        let upgradeSceneRoot = SKSpriteNode()
            upgradeSceneRoot.name = "upgrade_rootView"
            upgradeSceneRoot.zPosition = 10.0
        
        let bground = SKSpriteNode()
            bground.size = self.size
            bground.color = .black
            bground.name = "upgrade_background"
            bground.alpha = 0.0
            bground.run(SKAction.fadeAlpha(to: 0.7, duration: 0.15))
            upgradeSceneRoot.addChild(bground)
        
        
        let contentRoot = SKSpriteNode()
            contentRoot.setScale(0.1)
            contentRoot.alpha = 0.1
            contentRoot.name = "upgrade_contentRoot"
            upgradeSceneRoot.addChild(contentRoot)
        
        // Upgrade Box
        let upgradeBox = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeBox))
            upgradeBox.size.width = screenSize.width * 0.896
            upgradeBox.size.height = screenSize.height * 0.493
            upgradeBox.name = Global.Main.Character_Menu_UpgradeBox.rawValue
            contentRoot.addChild(upgradeBox)
        
        // Upgrade Icon Shade
        let iconShade = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeIconShade))
            iconShade.size = CGSize(width: screenSize.width*0.454, height: screenSize.height*0.255)
            iconShade.position.y += upgradeBox.size.height/4.5
            iconShade.alpha = 0.6
            iconShade.name = Global.Main.Character_Menu_UpgradeIconShade.rawValue
            upgradeBox.addChild(iconShade)
        
        // Upgrade Icon
        let icon = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeIcon))
            icon.name = Global.Main.Character_Menu_UpgradeIcon.rawValue
            icon.size = CGSize(width: screenSize.width*0.287, height: screenSize.height*0.162)
            icon.position.y += upgradeBox.size.height/4.5
            upgradeBox.addChild(icon)
        
        // Icon Sprite (Bullet Display)
        
        let iconSprite = bulletMaker.make(level: blevel, char: currToon)
            iconSprite.name = "projectile"
            icon.addChild(iconSprite)
        
        // Upgrade Arrow
        let arrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeArrow))
            arrow.size = CGSize(width: screenSize.width*0.051, height: screenSize.height*0.031)
            arrow.setScale(1.5)
            arrow.position.y -= arrow.size.height
            upgradeBox.addChild(arrow)
        
        // Upgrade Button
        let button = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeGreenButton))
            button.name = Global.Main.Character_Menu_UpgradeGreenButton.rawValue
            button.size = CGSize(width: upgradeBox.size.width * 0.31, height: upgradeBox.size.height*0.103)
            button.position.y -= upgradeBox.size.height/3.0
            upgradeBox.addChild(button)
        
        // Price Label
        let priceLabel = SKLabelNode(fontNamed: "Cartwheel")
            priceLabel.name = "label"
            priceLabel.text = "\(String(nextBulletLevel * 100))"
            priceLabel.fontSize = button.size.width/4.5
            priceLabel.position.x += button.size.width/5.5
            priceLabel.position.y -= button.size.height/4.5
            priceLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            priceLabel.horizontalAlignmentMode = .right
            priceLabel.name = "label"
            button.addChild(priceLabel.shadowNode(nodeName: "pricelabelshadow"))
        
        // Close Button
        let closeButton = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_UpgradeCloseButton))
            closeButton.size = CGSize(width: screenSize.width*0.094, height: screenSize.height*0.049)
            closeButton.name = Global.Main.Character_Menu_UpgradeCloseButton.rawValue
            closeButton.anchorPoint = CGPoint(x: 0.75, y: 0.75)
            closeButton.position.x = upgradeBox.frame.maxX
            closeButton.position.y = upgradeBox.frame.maxY
            upgradeBox.addChild(closeButton)
        
        // Left Text Area
        let leftTextArea = SKSpriteNode()
            leftTextArea.size = CGSize(width: upgradeBox.size.width/4.0, height: upgradeBox.size.width/4.0)
            leftTextArea.color = .clear
            leftTextArea.name = "lefttextarea"
            leftTextArea.position.y = arrow.position.y
            leftTextArea.position.x -= upgradeBox.size.width/4
            upgradeBox.addChild(leftTextArea)
        
        let leftLevelLabel = SKLabelNode()
            leftLevelLabel.name = "label"
            leftLevelLabel.text = "Lv \(String(toonLevel))"
            leftLevelLabel.fontSize = leftTextArea.size.width/3.0
            leftLevelLabel.horizontalAlignmentMode = .left
            leftLevelLabel.fontName = "Cartwheel"
            leftLevelLabel.position.x -= leftTextArea.size.width/4
            leftTextArea.addChild(leftLevelLabel.shadowNode(nodeName: "leftlevellabelshadow"))
        
        let leftDmgLabel = SKLabelNode()
            leftDmgLabel.fontName = "GillSans-Bold"
            leftDmgLabel.text = "DMG: \(String(20 + toonLevel*5))"
            leftDmgLabel.name = "leftdmglabel"
            leftDmgLabel.horizontalAlignmentMode = .left
            leftDmgLabel.fontColor = .brown
            leftDmgLabel.fontSize = leftTextArea.size.width/6.0
            leftDmgLabel.position.x -= leftTextArea.size.width/3.0
            leftDmgLabel.position.y -= leftTextArea.size.height/3.8
            leftTextArea.addChild(leftDmgLabel)
        
        // Right Text Area
        let rightTextArea = SKSpriteNode()
        rightTextArea.size = CGSize(width: upgradeBox.size.width/4.0, height: upgradeBox.size.width/4.0)
            rightTextArea.name = "righttextarea"
            rightTextArea.color = .clear
            rightTextArea.position.y = arrow.position.y
            rightTextArea.position.x += upgradeBox.size.width/4
            upgradeBox.addChild(rightTextArea)
        
        let rightLevelLabel = SKLabelNode()
                rightLevelLabel.text = "Lv \(String(toonLevel+1))"
                rightLevelLabel.fontSize = rightTextArea.size.width/3.0
                rightLevelLabel.name = "label"
                rightLevelLabel.horizontalAlignmentMode = .left
                rightLevelLabel.fontName = "Cartwheel"
                rightLevelLabel.fontColor = .orange
                rightLevelLabel.position.x -= rightTextArea.size.width/3.0
                rightTextArea.addChild(rightLevelLabel.shadowNode(nodeName: "rightlevellabelshadow"))
        
        let rightDmgLabel = SKLabelNode()
            rightDmgLabel.fontName = "GillSans-Bold"
            rightDmgLabel.text = "DMG: \(String(20 + (toonLevel+1)*5))"
            rightDmgLabel.horizontalAlignmentMode = .left
            rightDmgLabel.name = "rightdmglabel"
            rightDmgLabel.fontColor = .brown
            rightDmgLabel.fontSize = rightTextArea.size.width/6.0
            rightDmgLabel.position.x -= rightTextArea.size.width/2.5
            rightDmgLabel.position.y -= rightTextArea.size.height/3.8
            rightTextArea.addChild(rightDmgLabel)
        
        // Action Show Up
        let scaleAction = SKAction.scale(to: 1.0, duration: 0.15)
        let fadeIn = SKAction.fadeIn(withDuration: 0.15)
            contentRoot.run(SKAction.group([scaleAction, fadeIn]))
        
            addChild(upgradeSceneRoot)
        
        return true
    }
    
    private func updateUpgradeScene(){
        
        let toon = CurrToon(rawValue: currToonIndex)!
        let currLevelBullet = gameinfo.requestToonBulletLevel(index: currToonIndex)
        let nextLevelBullet = currLevelBullet + 1
        guard let currToon = Toon.Character(rawValue: toon.string),
              let blevel = BulletMaker.Level(rawValue: nextLevelBullet)
        else{return}
        
        
        
        let root = self.childNode(withName: "upgrade_rootView")!
        let contentRoot = root.childNode(withName: "upgrade_contentRoot")!
        let upgradeBox = contentRoot.childNode(withName: Global.Main.Character_Menu_UpgradeBox.rawValue)!
        
        let leftside = upgradeBox.childNode(withName: "lefttextarea")!
        let leftshadow = leftside.childNode(withName: "leftlevellabelshadow") as! SKEffectNode
        let leftLabel = leftshadow.childNode(withName: "label") as! SKLabelNode
        let leftDmgLabel = leftside.childNode(withName: "leftdmglabel") as! SKLabelNode
        
        let rightside = upgradeBox.childNode(withName: "righttextarea")!
        let rightshadow = rightside.childNode(withName: "rightlevellabelshadow") as! SKEffectNode
        let rightLabel = rightshadow.childNode(withName: "label") as! SKLabelNode
        let rightDmgLabel = rightside.childNode(withName: "rightdmglabel") as! SKLabelNode
        
        let upgradeButton = upgradeBox.childNode(withName: Global.Main.Character_Menu_UpgradeGreenButton.rawValue)
        let buttonShadow = upgradeButton?.childNode(withName: "pricelabelshadow") as! SKEffectNode
        let buttonLabel = buttonShadow.childNode(withName: "label") as! SKLabelNode
        
        let icon = upgradeBox.childNode(withName: Global.Main.Character_Menu_UpgradeIcon.rawValue)!
        
        if let bullet = icon.childNode(withName: "projectile"){
            bullet.removeFromParent()
        }
        
            let newBullet = bulletMaker.make(level:  blevel, char: currToon)
            newBullet.name = "projectile"
            icon.addChild(newBullet)
            leftLabel.text = "LV \(String(currLevelBullet))"
            leftDmgLabel.text = "DMG: \(String(20 + (currLevelBullet)*5))"
            rightDmgLabel.text = "DMG: \(String(20 + (currLevelBullet+1)*5))"
            rightLabel.text = "LV \(String(nextLevelBullet))"
            buttonLabel.text = String(nextLevelBullet * 100)
        
        
    }
    private func closeUpgrade(){
        let upgradeSceneRoot = self.childNode(withName: "upgrade_rootView")!
        let bground = upgradeSceneRoot.childNode(withName: "upgrade_background")!
        let contentRoot = upgradeSceneRoot.childNode(withName: "upgrade_contentRoot")!
        bground.run(SKAction.fadeAlpha(to: 0.0, duration: 0.1))
        
        let scaleAction = SKAction.scale(to: 0.0, duration: 0.1)
        let fadeIn = SKAction.fadeOut(withDuration: 0.1)
        contentRoot.run(SKAction.group([scaleAction, fadeIn]))
        
        upgradeSceneRoot.run(SKAction.sequence([SKAction.wait(forDuration: 0.15), SKAction.removeFromParent()]))
        state = .Select
    }
    
}
