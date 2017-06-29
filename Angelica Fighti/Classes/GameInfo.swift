//
//  GameInfo.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/2/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation
import SpriteKit


protocol GameInfoDelegate{
    
    var mainAudio:AVAudio {get}
    func addChild(_ sknode: SKNode)
    func changeGameState(_ state: GameState)
    func getCurrentToonNode() -> SKSpriteNode
    
}

class GameInfo: GameInfoDelegate{
    
    deinit {
        print ("GameInfo Class deinitiated!")
    }
    
    // Debug Variables
    fileprivate var counter:Int = 0 // only for debug - no purpose
    fileprivate var debugMode:Bool
    
    // Main Variables
    weak fileprivate var mainScene:SKScene?
    fileprivate var account:AccountInfo
    fileprivate var currentLevel:Int
    fileprivate var currentGold:Int  // tracking local current in-game
    fileprivate var currentHighscore:Int
    fileprivate var timer:Timer?
    
    // Secondary Variables
    fileprivate var wavesForNextLevel:Int = 10
    fileprivate var gamestate:GameState
    fileprivate var timePerWave:Double // time to call each wave
    
    // Extra Variables - Maybe need to be removed later on
    private var spawningDelay:Int = 0
    private var accountGoldLabel:HUD?
    
    // Public Variables
    var mainAudio:AVAudio
    var regular_enemies:EnemyModel
    var boss:EnemyModel
    var fireball_enemy:EnemyModel
    var map:Map?
    
     init(){

        debugMode = false
        mainAudio = AVAudio()
        currentLevel = 0
        currentGold = 0
        currentHighscore = 0
        account = AccountInfo()
        fireball_enemy = EnemyModel(type: .Fireball)
        regular_enemies = EnemyModel(type: .Regular)
        boss = EnemyModel(type: .Boss)
        gamestate = .NoState
        timePerWave = 3.0 // 3.0 is default
        
        // delegates
        regular_enemies.delegate = self
        boss.delegate = self
        fireball_enemy.delegate = self

    }
    
    func load(scene: SKScene) -> (Bool, String){
        
        var loadStatus:(Bool, String) = (true, "No errors")
        
        mainScene = scene
        
        // play background music
        mainAudio.play(type: .Background_Start)
        if !account.load(){
            return (false, "account error")
        }
        
        self.loadInfoBar()
        
        loadStatus = self.createWalls(leftXBound: 0, rightXBound:screenSize.width, width: 50, height: screenSize.height)
        
        // Load debug. Note: It will execute only if debugMode == true
        loadStatus = self.loadDebugVersion()
        
        return loadStatus
    }
    
    private func loadDebugVersion() -> (Bool, String){
        
        // Note: Fourthbar was removed. Add it if needed
        
        if debugMode == false{
            return (true, "No Errors")
        }
        
        guard let scene = mainScene else {
            return (false, "Gameinfo.loadDebugVersion - Scene is nil")
        }
        
        guard let infobar = scene.childNode(withName: "infobar") as? SKSpriteNode else{
            return (false, "Gameinfo.loadDebugVersion - infobar is nil")
        }
        
        guard let topbar_first = infobar.childNode(withName: "topbar_first_item") as? SKSpriteNode else{
            return (false, "Gameinfo.loadDebugVersion - topbar_first is nil")
        }
        guard let topbar_second = infobar.childNode(withName: "topbar_second_item") as? SKSpriteNode else{
            return (false, "Gameinfo.loadDebugVersion - topbar_second is nil")
        }
        guard let topbar_third = infobar.childNode(withName: "topbar_third_item") as? SKSpriteNode else{
            return (false, "Gameinfo.loadDebugVersion - topbar_third is nil")
        }
        
        infobar.color = .red
        topbar_first.color = .yellow
        topbar_second.color = .blue
        topbar_third.color = .brown
        
        return (true, "No errors")
    }
    
    
    private func loadInfoBar(){
        
        let mainRootWidth:CGFloat = screenSize.width
        let mainRootHeight:CGFloat = 100
        
        
         func getRootModelNode(width w:CGFloat, height h:CGFloat, dx:CGFloat, name n:String) -> SKSpriteNode{
           
            let node = SKSpriteNode()
                node.anchorPoint = CGPoint(x: 0, y: 0)
                node.color = .clear
                node.name = n
                node.size = CGSize(width: w, height: h)
                node.position = CGPoint(x: dx, y: mainRootHeight - h)

            return node
        }
        
         func fillNode(node:SKSpriteNode, barName:String, barSprite: Global.Main, iconName:String, iconSprite: Global.Main){
            
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
            
            // Testing
            let hudPos = CGPoint(x: bar.size.height*2, y: bar.size.height/2)
                self.accountGoldLabel = HUD(width: bar.size.width, height: bar.size.height, position: hudPos, type: .Gold)
                node.addChild(accountGoldLabel!.getNode(text: String(self.account.getGoldAmount()))!)
            
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
         func template(itemSize: CGSize, name n:String, barSprite: Global.Main, iconSprite: Global.Main, previousPos prev:CGPoint?) -> SKNode{
            
            var px:CGFloat!
            
            let (w, h) = (itemSize.width, itemSize.height)
            
                px = (prev == nil) ? 0.0 : prev!.x + w
            
            let node = getRootModelNode(width: w, height: h, dx: px,  name: n)
            
                fillNode(node: node, barName: barSprite.rawValue, barSprite: barSprite, iconName: iconSprite.rawValue, iconSprite: iconSprite)
        
            return node
        }
        
        // fourth item
         func customFourthLabel(itemSize:CGSize, prevNodePosition prev:CGPoint) -> SKNode{
            
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
            let labelYpos:CGFloat = goldIcon.position.y/2
            let labelText = SKLabelNode(fontNamed: "Courier")
            labelText.text = "\(String(counter))"
            labelText.fontSize = 26
            labelText.fontColor = .brown
            labelText.horizontalAlignmentMode = .right
            labelText.position = CGPoint(x: labelXPos, y:labelYpos)
            labelText.name = "coinCounter"
            node.addChild(labelText)
            
            
            node.alpha = 0.0
            return node
        }
        
        
        let infobar = SKSpriteNode()
        let rootItemSize:CGSize = CGSize(width: screenSize.width/4, height: screenSize.height*0.05)
        
        infobar.color = .clear
        infobar.name = "infobar"
        infobar.size = CGSize(width: mainRootWidth, height: mainRootHeight)
        infobar.anchorPoint = CGPoint(x: 0, y: 0)
        infobar.position = CGPoint(x: 0, y: screenSize.height - mainRootHeight)
        self.addChild(infobar)
        
        let firstItem = template(itemSize: rootItemSize, name: "topbar_first_item", barSprite:.Main_Menu_Level_Bar, iconSprite: .Main_Menu_Level_Badge, previousPos: nil)
        let secondItem = template(itemSize: rootItemSize, name: "topbar_second_item", barSprite:.Main_Menu_Currency_Bar, iconSprite: .Main_Menu_Coin, previousPos: firstItem.position)
        let thirdItem = template(itemSize: rootItemSize, name: "topbar_third_item", barSprite:.Main_Menu_Currency_Bar, iconSprite: .Main_Menu_Trophy, previousPos: secondItem.position)
        let fourthItem = customFourthLabel(itemSize: rootItemSize, prevNodePosition: thirdItem.position)
        
        
        // adding first
        infobar.addChild(firstItem)
        
        // adding second
        infobar.addChild(secondItem)
        
        // adding third
        infobar.addChild(thirdItem)
        
        // adding fourth
        infobar.addChild(fourthItem)
        
    }
    
    
    private func createWalls(leftXBound:CGFloat, rightXBound:CGFloat, width:CGFloat, height:CGFloat) -> (Bool, String){
        
        guard let mainscene = mainScene else{
            return (false, "mainScene is nil")
        }
        // create invisible wall
        
        let leftWall = SKSpriteNode()
        leftWall.name = "leftWall"
        leftWall.physicsBody =  SKPhysicsBody(edgeFrom: CGPoint(x: leftXBound, y: 0), to: CGPoint(x: leftXBound, y: screenSize.height))
        leftWall.physicsBody!.isDynamic = false
        leftWall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        mainscene.addChild(leftWall)
        
        let rightWall = SKSpriteNode()
        rightWall.name = "rightWall"
        rightWall.physicsBody =  SKPhysicsBody(edgeFrom: CGPoint(x: rightXBound, y: 0), to: CGPoint(x: rightXBound, y: screenSize.height))
        rightWall.physicsBody!.isDynamic = false
        rightWall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        mainscene.addChild(rightWall)
        
        return (true, "No errors")
    }
    private func spawnEnemies(scene: SKScene, totalWaves: Int){
        
        //update state
        self.changeGameState(.Spawning)
   
        let action = SKAction.sequence([SKAction.run({
            self.regular_enemies.spawn(scene: scene)
        }), SKAction.wait(forDuration: 3)])
        
        //totalWaves
        let spawnAction = SKAction.repeat(action, count: totalWaves)
        let endAction = SKAction.run(didFinishSpawningEnemy)
        
        scene.run(SKAction.sequence([spawnAction, endAction]))
        
    }
    
    private func didFinishSpawningEnemy(){
        
        mainScene!.run(SKAction.sequence([SKAction.run {
            // update gamestate
            self.changeGameState(.BossEncounter)
            // show boss incoming
            }, SKAction.wait(forDuration: 5), SKAction.run {
                // summon boss
                self.boss.spawn(scene: self.mainScene!)
            }]))
    }
    
    private func updateGoldLabel(){
        
        guard let mainscene = mainScene else{
            print ("ERROR A00: Check Update() from GameInfo")
            return
        }
        
        guard let infobar = mainscene.childNode(withName: "infobar") else{
            print ("ERROR A01: Check Update() from GameInfo")
            return
        }
        
        guard let toprightCorner = infobar.childNode(withName: "topbar_right_corner") as? SKSpriteNode else{
            print ("ERROR A02: Check Update() from Class GameInfo")
            return
        }
        
        guard let coinLabelText = toprightCorner.childNode(withName: "coinCounter") as? SKLabelNode else{
            print ("ERROR A03: Check Update() from Class GameInfo")
            return
        }
        
        coinLabelText.text = String(self.currentGold)
    }
    
    //  Only called when the gamestate is spawning. 
    //  This function is called every second.
    @objc func running(){
        let random = randomInt(min: 0, max: 100)
        // Fireball
        if random < 10 {
            print("Fireball called with random: ", random)
            fireball_enemy.spawn(scene: mainScene!)
        }
        
    }
    
    // Notification
    //func updateGameState(notification: Notification){
    func updateGameState(){
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check updateGameState() from GameInfo")
            return
        }
        
        guard let infobar = mainscene.childNode(withName: "infobar") else{
            print ("ERROR D01: Check updateGameState() from GameInfo")
            return
        }
        
        guard let toprightCorner = infobar.childNode(withName: "topbar_right_corner") as? SKSpriteNode else{
            print ("ERROR D02: Check updateGameState() from Class GameInfo")
            return
        }
        
        switch gamestate {
        case .Start:
                // Load Map
                map = Map(maps: global.getTextures(textures: .Map_Ragnarok), scene: mainscene)

                // TopBar Actions
                let fadeAwayAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
                
                let coinAction = SKAction.group([SKAction.moveBy(x: 0, y: -100, duration: 0.3), SKAction.fadeAlpha(to: 1.0, duration: 0.3)])
                
                let topbarAction = SKAction.group([SKAction.run(fadeAwayAction, onChildWithName: "topbar_first_item"), SKAction.run(fadeAwayAction, onChildWithName: "topbar_second_item"), SKAction.run(fadeAwayAction, onChildWithName: "topbar_third_item")])
                
                // Cloud action
                let moveDownCloud = SKAction.moveTo(y: -screenSize.height*1.5, duration: 1)
                
                // Buildings Action
                let scaleAction = SKAction.scale(to: 0.7, duration: 0.3)
                let moveAction = SKAction.moveTo(y: screenSize.height/3, duration: 0.3)
                let buildingsAction = SKAction.sequence([SKAction.run(SKAction.group([scaleAction, moveAction]), onChildWithName: "main_menu_middle_root"), SKAction.wait(forDuration: 1.5), SKAction.run {
                    self.mainScene!.childNode(withName: "main_menu_middle_root")!.removeFromParent()
                    self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_1.rawValue)!.removeFromParent()
                    self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_2.rawValue)!.removeFromParent()
                    self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_3.rawValue)!.removeFromParent()
                    self.map!.run()
                    
                    }])
                
                // Create 4 clouds
                for i in 0...3{
                    let cloud = SKSpriteNode()
                    if ( i % 2 == 0){
                        cloud.texture = global.getMainTexture(main: .StartCloud_1)
                        cloud.name = Global.Main.StartCloud_1.rawValue + String(i)
                    }
                    else{
                        cloud.texture = global.getMainTexture(main: .StartCloud_2)
                        cloud.name = Global.Main.StartCloud_2.rawValue + String(i)
                    }
                    cloud.size = CGSize(width: screenSize.width, height: screenSize.height*1.5)
                    cloud.anchorPoint = CGPoint(x: 0.5, y: 0)
                    cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height)
                    cloud.zPosition = -1
                    mainscene.addChild(cloud)
                }
                
                // Running Actions
                infobar.run(topbarAction)
                toprightCorner.run(coinAction)
                
                mainscene.run(SKAction.sequence([SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "0"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "1"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "2"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "3")]))
                
                mainscene.run(SKAction.sequence([buildingsAction, SKAction.wait(forDuration: 3), SKAction.run{self.changeGameState(.WaitingState)
                    }, SKAction.wait(forDuration: 0.2), SKAction.run { self.account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                        self.addChild(self.account.getCurrentToon().getBullet().shoot())
                        }, SKAction.wait(forDuration: 0.06)])))
                    }]))
        case .WaitingState:
            // start enemy respawn
            wavesForNextLevel = randomInt(min: 5, max: 10)
            regular_enemies.increaseHP()
            
            // increase enemy speed
            regular_enemies.increaseVelocityBy(amount: 50.0)
            print(" Waves for next Boss: \(wavesForNextLevel)")
            
            mainScene!.run(SKAction.sequence([SKAction.wait(forDuration: 2.5), SKAction.run {
                self.spawnEnemies(scene: mainscene, totalWaves: self.wavesForNextLevel)
                }]))
            
        case .Spawning:
            // use this place to activate timer. Run a function called Running() 
            print("Spawning")
            //timer = Timer(timeInterval: 1, target: self, selector: #selector(running), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(running), userInfo: nil, repeats: true)
        case .BossEncounter:
            // use this state to cancel the timer - invalidate
            print("Boss Encounter")
            timer?.invalidate()
       
        default:
            print("Current State: ", gamestate)
        }
    }
    
    // Public Functions:
    internal func getCurrentToon() -> Toon{
        return account.getCurrentToon()
    }
    internal func getCurrentToonNode() -> SKSpriteNode{
       return account.getCurrentToon().getNode()
    }
    
    internal func getCurrentToonIndex() -> Int{
        return account.getCurrentToonIndex()
    }
    
    internal func getCurrentToonBullet() -> Projectile{
        return account.getCurrentToon().getBullet()
    }
    
    internal func getCurrentToonBulletEmmiterNode(x px:CGFloat, y py:CGFloat) -> SKEmitterNode{
        return account.getCurrentToon().getBullet().generateTouchedEnemyEmmiterNode(x: px, y: py)
    }
    internal func prepareToChangeScene(){
        
        //NotificationCenter.default.removeObserver(self, name: updateNotification, object: nil)
        boss.delegate = nil
        regular_enemies.delegate = nil
        fireball_enemy.delegate = nil
        mainAudio.stop()
        map?.prepareToChangeScene()
        timer?.invalidate()
    }
    internal func selectToonIndex(index: Int){
        self.account.selectToonIndex(index: index)
    }
    internal func getDescriptionOfToonByIndex(index id:Int) -> [String]{
        return self.account.getToonDescriptionByIndex(index: id)
    }
    
    internal func getNameOfToonByIndex(index id:Int) -> String{
        return self.account.getNameOfToonByIndex(index: id)
    }
    
    internal func getTitleOfToonByIndex(index id:Int) -> String{
        return self.account.getTitleOfToonByIndex(index: id)
    }
    
    // Maybe change this later to something like:
    // Enum CurrencyType: .Gold, .Diamond... etc
    internal func addCoin(amount:Int){
        currentGold += amount
        updateGoldLabel()
    }
    
    internal func getCurrentGold() -> Int{
        return self.currentGold
    }
    
    
   
    // delegate functions
    internal func addChild(_ sknode: SKNode){
        guard let mainscene = mainScene else{
            print ("Error:: mainScene does not exist - check Gameinfo Class/ addChild Function")
            return
        }
        mainscene.addChild(sknode)
    }
    
    internal func changeGameState(_ state: GameState){
        gamestate = state
        updateGameState()
        //NotificationCenter.default.post(name: updateNotification, object: nil)
    }
    
}
