//
//  Classes.swift
//  Angelica Fight
//
//  Created by Guan Wong on 12/22/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

import ObjectiveC


protocol GameInfoDelegate{
    
    var mainAudio:AVAudio {get}
    func addChild(sknode: SKNode)
    func updateGameState(state: GameState)
    
}

protocol ProjectileDelegate{
    
    func add(sknode: SKNode)
}

enum GameState{
    case Spawning  // state which waves are incoming
    case BossEncounter // boss encounter
    case WaitingState // Need an state
    case NoState
}

enum ProjectileType{
    case type1
    case type2
    case type3
    
}

enum ContactType{
    case HitByEnemy
    case EnemyGotHit
    case PlayerGetCoin
    case Immune
    case None
}

class Global {
    
    deinit {
        print ("Global is deiniiated")
    }
    
    enum Animation{
        case Boss_1_Dead_Animation
        case Boss_1_Move_Animation
        case Puff_Animation
        case Gold_Animation
        case Player_Toon_1_Animation
        case Map_Ragnarok
    }
    
    enum Main:String{
        
        case Boss_1 = "boss_1"
        case Player_Toon_1
        case Gold
        case Enemy_1
        case Enemy_2
        case Enemy_3
        case Enemy_4
        case Enemy_5
        case Enemy_6
        case Enemy_7
        case Main_Menu_Background_1 = "main_background_1"
        case Main_Menu_Background_2 = "main_background_2"
        case Main_Menu_Background_3 = "main_background_3"
        case Main_Menu_Building_1
        case Main_Menu_Building_2
        case Main_Menu_Building_3
        case Main_Menu_Building_1_Additional
        case Main_Menu_Level_Badge = "main_menu_level_badge"
        case Main_Menu_Level_Bar = "main_menu_level_bar"
        case Main_Menu_Level_Progress = "main_menu_level_progress"
        case Main_Menu_Coin = "main_menu_coin"
        case Main_Menu_Currency_Bar = "main_menu_currency_bar"
        case Main_Menu_Trophy = "main_menu_trophy"
        case Main_Menu_Arrow = "main_menu_arrow"
        case Main_Menu_Drag_To_Start = "main_menu_start_game"
        case PurpleButton
        case StartCloud_1 = "startcloud_1"
        case StartCloud_2 = "startcloud_2"
        
        
    }
    
    enum HUD{
        case Gold
        case Trophy
    }
    enum BossAttack{
        case Boss1_type_1
    }
    
    private enum MainMenu{
        case Waterfall
        case Building
        case Smoke
        case Background
        case Level
        case Currency
        case Text
    }
    
    private enum MapType{
        case Ragnarok
    }
   /*  --> For future implementation
    enum TypeBoss{
        case mainTexture
        case attackTexture
        case dieAnimation
        case moveAnimation
    }
    private var boss_1 = [TypeBoss:Any]()*/
    
    private var boss_1_main:SKTexture
    private var boss_1_attack_1:SKTexture
    private var boss_1_die_animation:[SKTexture] = []
    private var boss_1_movement_animation:[SKTexture] = []
    
    private var puff_regular_animation:[SKTexture] = []
    
    private var gold_main:SKTexture
    private var gold_animation:[SKTexture] = []
    
    private var player_toon1_main:SKTexture
    private var player_toon1_animation:[SKTexture] = []
    
    private var enemy_main_collection = [SKTexture]()
    
    private var main_menu_collection = [MainMenu:[SKTexture]]() // All Sprites used in Main Menu
    
    private var purple_button:SKTexture
    
    private var gold_hud:[SKTexture] = []
    
    private var start_cloud:[SKTexture] = []
    
    private var map = [MapType:[SKTexture]]()
    
    init (){
        
        let atlas = SKTextureAtlas(named: "images")
        boss_1_main = atlas.textureNamed("boss-1-main")
        boss_1_attack_1 = atlas.textureNamed("enemy_attack_ball")
        gold_main = atlas.textureNamed("gold_main")
        player_toon1_main = atlas.textureNamed("toon_1_main")
        purple_button = atlas.textureNamed("PurpleButton")
        
        main_menu_collection[.Background] = []
        main_menu_collection[.Building] = []
        main_menu_collection[.Waterfall] = []
        main_menu_collection[.Smoke] = []
        main_menu_collection[.Level] = []
        main_menu_collection[.Currency] = []
        main_menu_collection[.Text] = []
        
        map[.Ragnarok] = []
        
        for texture in atlas.textureNames{
            print(texture)
            if texture.contains("enemy") && texture.contains("main"){
            enemy_main_collection.append(atlas.textureNamed("enemy_\(enemy_main_collection.count+1)_main"))
            }
            
            else if texture.contains("boss_1_movement"){
               boss_1_movement_animation.append(atlas.textureNamed("boss_1_movement\(boss_1_movement_animation.count + 1)"))
            }
            
            else if texture.contains("boss_1_die"){
                boss_1_die_animation.append(atlas.textureNamed("boss_1_die\(boss_1_die_animation.count + 1)"))
            }
            
            else if texture.contains("puff_regular"){
               puff_regular_animation.append(atlas.textureNamed("puff_regular\(puff_regular_animation.count + 1)"))
            }
            
            else if texture.contains("gold_action"){
                gold_animation.append(atlas.textureNamed("gold_action\(gold_animation.count + 1)"))
            }
            
            else if texture.contains("toon_1_action"){
                 player_toon1_animation.append(atlas.textureNamed("toon_1_action\(player_toon1_animation.count + 1)"))
            }
            
            else if texture.contains("hud_gold"){
                gold_hud.append(atlas.textureNamed("hud_gold_\(gold_hud.count)"))
            }
            
            else if texture.contains("start_cloud_"){
                start_cloud.append(atlas.textureNamed("start_cloud_\(start_cloud.count + 1)"))
            }
                
            else if texture.contains("map1_"){
                map[.Ragnarok]!.append(atlas.textureNamed("map1_\(map[.Ragnarok]!.count + 1)"))
            }
            
            else if texture.contains("main_menu_") && texture.contains("background"){
                main_menu_collection[.Background]!.append(atlas.textureNamed("main_menu_background_\(main_menu_collection[.Background]!.count + 1)"))
            }
            else if texture.contains("main_menu_") && texture.contains("building"){
                main_menu_collection[.Building]!.append(atlas.textureNamed("main_menu_building_\(main_menu_collection[.Building]!.count + 1)"))
            }
            else if texture.contains("main_menu_") && texture.contains("waterfall"){
                main_menu_collection[.Waterfall]!.append(atlas.textureNamed("main_menu_waterfall_\(main_menu_collection[.Waterfall]!.count + 1)"))
            }
            else if texture.contains("main_menu_") && texture.contains("level"){
                main_menu_collection[.Level]!.append(atlas.textureNamed("main_menu_level_\(main_menu_collection[.Level]!.count + 1)"))
            }
            else if texture.contains("main_menu_") && texture.contains("currency"){
                main_menu_collection[.Currency]!.append(atlas.textureNamed("main_menu_currency_\(main_menu_collection[.Currency]!.count + 1)"))
            }
            else if texture.contains("main_menu_") && texture.contains("text"){
                main_menu_collection[.Text]!.append(atlas.textureNamed("main_menu_text_\(main_menu_collection[.Text]!.count + 1)"))
            }
            
            
        }
    }
    
    func getHUDTexture(hudType:HUD, text:String) -> SKTexture{
        
        let num:Int!
        if text == ","{
            num = 10
        }
        else{
            num = Int(text)
        }
        switch hudType {
        case .Gold:
            return gold_hud[num]
        default:
            print("Should not reach here... Default from getHUDTexture method.")
            return gold_hud[num]
        }
    }
    
    func getTextures(textures:Animation) -> [SKTexture]{
        switch textures{
        case .Boss_1_Dead_Animation:
            return boss_1_die_animation
        case .Boss_1_Move_Animation:
            return boss_1_movement_animation
        case .Gold_Animation:
            return gold_animation
        case .Player_Toon_1_Animation:
            return player_toon1_animation
        case .Puff_Animation:
            return puff_regular_animation
        case .Map_Ragnarok:
            return map[.Ragnarok]!
            
        }
        
    }
    func getMainTexture(main: Main) -> SKTexture{
        switch main{
        case .Boss_1:
            return boss_1_main
        case .Gold:
            return gold_main
        case .Player_Toon_1:
            return player_toon1_main
        case .Enemy_1:
            return enemy_main_collection[0]
        case .Enemy_2:
            return enemy_main_collection[1]
        case .Enemy_3:
            return enemy_main_collection[2]
        case .Enemy_4:
            return enemy_main_collection[3]
        case .Enemy_5:
            return enemy_main_collection[4]
        case .Enemy_6:
            return enemy_main_collection[5]
        case .Enemy_7:
            return enemy_main_collection[6]
        case .Main_Menu_Background_1:
            return main_menu_collection[.Background]![0]
        case .Main_Menu_Background_2:
            return main_menu_collection[.Background]![1]
        case .Main_Menu_Background_3:
            return main_menu_collection[.Background]![2]
        case .Main_Menu_Building_1:
            return main_menu_collection[.Building]![0]
        case .Main_Menu_Building_2:
            return main_menu_collection[.Building]![1]
        case .Main_Menu_Building_3:
            return main_menu_collection[.Building]![2]
        case .Main_Menu_Building_1_Additional:
            return main_menu_collection[.Building]![3]
        case .PurpleButton:
            return purple_button
        case .Main_Menu_Level_Badge:
            return main_menu_collection[.Level]![0]
        case .Main_Menu_Level_Bar:
            return main_menu_collection[.Level]![1]
        case .Main_Menu_Level_Progress:
            return main_menu_collection[.Level]![2]
        case .Main_Menu_Coin:
            return main_menu_collection[.Currency]![0]
        case .Main_Menu_Currency_Bar:
            return main_menu_collection[.Currency]![1]
        case .Main_Menu_Trophy:
            return main_menu_collection[.Currency]![2]
        case .Main_Menu_Drag_To_Start:
            return main_menu_collection[.Text]![0]
        case .Main_Menu_Arrow:
            return main_menu_collection[.Text]![1]
        case .StartCloud_1:
            return start_cloud[0]
        case .StartCloud_2:
            return start_cloud[1]
        }
    }
    
    func getAttackTexture(attack: BossAttack) -> SKTexture{
        switch (attack){
        case .Boss1_type_1:
            return boss_1_attack_1
        }
    }
}

let global:Global = Global() // Using this class to hold all paths/directories

struct AVAudio {
    
    enum SoundType{
        case Coin
        case Puff
    }
    
    enum BgroundSoundType{
        case Background_Start
    }
    
    //private var audio
    private var bground_1_player:AVAudioPlayer

    init(){
        
        let bground_1_player_dir = Bundle.main.url(forResource: "begin", withExtension: "m4a", subdirectory: "BGM")
        
        guard let bground_1 = try? AVAudioPlayer(contentsOf: bground_1_player_dir! as URL) else{
            fatalError("Failed to initialize the audio player bground_1")
        }
  
        bground_1.volume = 1.0
        
        bground_1.prepareToPlay()
        
        bground_1_player = bground_1
    }

    func play(type: BgroundSoundType){
        switch type{
        case .Background_Start:
            bground_1_player.numberOfLoops = -1
            bground_1_player.currentTime = 0
            bground_1_player.play()
            
        }
    }
    
    func getAction(type: SoundType) -> SKAction{
        switch type{
        case .Coin:
            let skCoinAction = SKAction.playSoundFileNamed("SoundEffects/getcoin.m4a", waitForCompletion: true)
            return skCoinAction
        case .Puff:
            
            let skPuffAction = SKAction.playSoundFileNamed("SoundEffects/puff.m4a", waitForCompletion: true)
            return skPuffAction
        }
    }
    
    func load() -> Bool{
      
        return true
    }
    
    func stop(){
        bground_1_player.stop()
    }
    }

class GameInfo: GameInfoDelegate{
    
    deinit {
        print ("GameInfo Class deinitiated!")
    }
    
    var counter:Int = 0 // only for debug - no purpose
    private var debugMode:Bool
    
    weak private var mainScene:SKScene?
    private var currentLevel:Int
    private var currentGold:Int  // tracking local current in-game
    private var currentHighscore:Int
    
    private var wavesForNextLevel:Int = 10
    private var isBossEncounter:Bool = false
    private var gamestate:GameState
    
    private var startgame:Bool = false
    
    private var timePerWave:Double // time to call each wave
    
    var mainAudio:AVAudio
    var account:AccountInfo
    var enemy:Enemy
    var boss:Enemy
    

    init(){
        debugMode = false
        mainAudio = AVAudio()
        currentLevel = 0
        currentGold = 0
        currentHighscore = 0
        account = AccountInfo()
        enemy = Enemy(type: .Regular)
        boss = Enemy(type: .Boss)
        gamestate = .NoState
        timePerWave = 3.0 // 3.0 is default
        
        // delegates
        enemy.delegate = self
        boss.delegate = self
    }

    
    func start(){
        startgame = true
    }
    
    func load(scene: SKScene) -> (Bool, String){
        
        
        mainScene = scene
        
        // play background music
        mainAudio.play(type: .Background_Start)
        
        if !account.load(){return (false, "account error")}
        
         addChild(sknode: account.getCurrentToon().getNode())
        
        loadInfoBar()
        
        createWalls(leftXBound: 0, rightXBound:screenSize.width, width: 50, height: screenSize.height )
        
        // load
        loadDebugVersion()
        
        return (true, "All Loaded")
    }
 
    func loadDebugVersion(){
        
        if debugMode == false{
            return
        }
        
        guard let scene = mainScene else {
            print("Debug returned. scene is nil")
            return
        }
        
        guard let infobar = scene.childNode(withName: "infobar") as? SKSpriteNode else{
            print("debug returned. infobar is nil")
            return
        }
        
        guard let topbar_first = infobar.childNode(withName: "topbar_first_item") as? SKSpriteNode else{
            print ("ERROR 000: Check loadDebugVersion() from Class GameInfo")
            return
        }
        guard let topbar_second = infobar.childNode(withName: "topbar_second_item") as? SKSpriteNode else{
            print ("ERROR 001: Check loadDebugVersion() from Class GameInfo")
            return
        }
        guard let topbar_third = infobar.childNode(withName: "topbar_third_item") as? SKSpriteNode else{
            print ("ERROR 002: Check loadDebugVersion() from Class GameInfo")
            return
        }
        /*guard let topbar_fourth = infobar.childNode(withName: "topbar_fourth_item") as? SKSpriteNode else{
            print ("ERROR 003: Check loadDebugVersion() from Class GameInfo")
            return
        }*/
        
        infobar.color = .red
        
        topbar_first.color = .yellow
        topbar_second.color = .blue //.blue
        topbar_third.color = .brown //.brown
      //  topbar_fourth.color = .green
    }
   
    
    func loadInfoBar(){
        
        let mainRootWidth:CGFloat = screenSize.width
        let mainRootHeight:CGFloat = 100
        
    
        func getRootModelNode(width w:CGFloat, height h:CGFloat, dx:CGFloat, name n:String) -> SKSpriteNode{
            let node = SKSpriteNode()
            
            node.anchorPoint = CGPoint(x: 0, y: 0)
           // node.color = .clear
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
            
            // icon
            let icon = SKSpriteNode()
            let iconWidth:CGFloat = node.size.height
            let iconHeight:CGFloat = node.size.height
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
            
            if prev == nil{
                px = 0.0
            }
            else{
                px = prev!.x + w
            }
            
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
            labelText.fontColor = UIColor.brown
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
        addChild(sknode: infobar)
        
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
 
    
    func createWalls(leftXBound:CGFloat, rightXBound:CGFloat, width:CGFloat, height:CGFloat){
        
        // create invisible wall
    
      let leftWall = SKSpriteNode()
        leftWall.name = "leftWall"
        leftWall.physicsBody =  SKPhysicsBody(edgeFrom: CGPoint(x: leftXBound, y: 0), to: CGPoint(x: leftXBound, y: screenSize.height))
        leftWall.physicsBody!.isDynamic = false
        leftWall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        self.addChild(sknode: leftWall)
        
        let rightWall = SKSpriteNode()
        rightWall.name = "rightWall"
        rightWall.physicsBody =  SKPhysicsBody(edgeFrom: CGPoint(x: rightXBound, y: 0), to: CGPoint(x: rightXBound, y: screenSize.height))
        rightWall.physicsBody!.isDynamic = false
        rightWall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        self.addChild(sknode: rightWall)
        
    }
 
    func CallSpawnEnemy(scene: SKScene, totalWaves: Int, waveTime:Double){
        
        // update state
        updateGameState(state: .Spawning)
        
        // run action
        let spawningActionSequence = SKAction.sequence([SKAction.run {
            self.enemy.spawnEnemy()
            self.wavesForNextLevel -= 1
            }, SKAction.wait(forDuration: waveTime)])
        
        let repeatSpawning = SKAction.repeat(spawningActionSequence, count: totalWaves)
        
        scene.run(SKAction.sequence([repeatSpawning, SKAction.run(self.didFinishSpawningEnemy)]), withKey: "callspawnenemy")
    }
    
    func didFinishSpawningEnemy(){
        // show boss incoming
        
        // update gamestate
        updateGameState(state: .BossEncounter)
        
        
        // summon boss
        self.boss.spawnEnemy()
    }
 
 
    
    func update(){
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
        
        if gamestate == .NoState{
            
            // Organize this part later.
            
            if startgame{
                
                // Load Map
                let map = Map(maps: global.getTextures(textures: .Map_Ragnarok), scene: mainscene)
                mainscene.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(map.update), SKAction.wait(forDuration: 0.01)])))
                
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
                    map.fadein()
                    map.run()
                    
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
                
                mainscene.run(SKAction.sequence([buildingsAction, SKAction.wait(forDuration: 3), SKAction.run { self.account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                        self.addChild(sknode: self.account.getCurrentToon().getBullet().shoot())
                        }, SKAction.wait(forDuration: 0.1)])))
                    self.gamestate = .WaitingState
                    
                    }]))
                
             startgame = false
                
            }
        }
        
        if (gamestate == .WaitingState){
            // start enemy respawn
            wavesForNextLevel = randomInt(min: 5, max: 10)
            enemy.increaseHP()
            
            // increase enemy speed
            enemy.increaseVelocityBy(amount: 50.0)
            
            print(" Waves for next Boss: \(wavesForNextLevel)")
            CallSpawnEnemy(scene: mainscene, totalWaves: wavesForNextLevel, waveTime: timePerWave)
          //  CallSpawnEnemy(scene: mainscene, totalWaves: wavesForNextLevel, waveTime: 3)
        }
        coinLabelText.text = String(self.currentGold)
    }
    
    func addCoin(amount:Int){
        currentGold += amount
    }
    
    func getCurrentGold() -> Int{
        return self.currentGold
    }
    
 
    
    func addChild(sknode: SKNode){
        guard let mainscene = mainScene else{
            print ("Error:: mainScene does not exist - check Gameinfo Class/ addChild Function")
            return
        }
        mainscene.addChild(sknode)
    }
    
    func updateGameState(state: GameState){
        gamestate = state
    }
    
}









