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
    case NoState // Need an state
    
}

enum ProjectileType{
    case type1
    case type2
    case type3
    
}

enum ContactType{
    case HitByEnemy
    case EnemyGotHit
    case BossGotHit
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
    }
    
    enum Main{
        
        case Boss_1
        case Player_Toon_1
        case Gold
        case Enemy_1
        case Enemy_2
        case Enemy_3
        case Enemy_4
        case Enemy_5
        case Enemy_6
        case Enemy_7
    }
    
    private var boss_1_main:SKTexture
    private var boss_1_die_animation:[SKTexture] = []
    private var boss_1_movement_animation:[SKTexture] = []
    
    private var puff_regular_animation:[SKTexture] = []
    
    private var gold_main:SKTexture
    private var gold_animation:[SKTexture] = []
    
    private var player_toon1_main:SKTexture
    private var player_toon1_animation:[SKTexture] = []
    
    private var enemy_1_main:SKTexture
    private var enemy_2_main:SKTexture
    private var enemy_3_main:SKTexture
    private var enemy_4_main:SKTexture
    private var enemy_5_main:SKTexture
    private var enemy_6_main:SKTexture
    private var enemy_7_main:SKTexture
    
    init (){
        
        let atlas = SKTextureAtlas(named: "images")
        
        boss_1_main = atlas.textureNamed("boss_1_main")
        gold_main = atlas.textureNamed("gold_main")
        player_toon1_main = atlas.textureNamed("toon_1_main")
        enemy_1_main = atlas.textureNamed("enemy_1_main")
        enemy_2_main = atlas.textureNamed("enemy_2_main")
        enemy_3_main = atlas.textureNamed("enemy_3_main")
        enemy_4_main = atlas.textureNamed("enemy_4_main")
        enemy_5_main = atlas.textureNamed("enemy_5_main")
        enemy_6_main = atlas.textureNamed("enemy_6_main")
        enemy_7_main = atlas.textureNamed("enemy_7_main")
        
        for texture in atlas.textureNames{
            
            if texture.contains("boss_1_movement"){
               boss_1_movement_animation.append(atlas.textureNamed("boss_1_movement\(boss_1_movement_animation.count + 1)"))
            }
            
            if texture.contains("boss_1_die"){
                boss_1_die_animation.append(atlas.textureNamed("boss_1_die\(boss_1_die_animation.count + 1)"))
            }
            
            if texture.contains("boss_1_die"){
               puff_regular_animation.append(atlas.textureNamed("puff_regular\(puff_regular_animation.count + 1)"))
            }
            
            if texture.contains("gold_action"){
                gold_animation.append(atlas.textureNamed("gold_action\(gold_animation.count + 1)"))
            }
            
            if texture.contains("toon_1_action"){
                 player_toon1_animation.append(atlas.textureNamed("toon_1_action\(player_toon1_animation.count + 1)"))
            }
            
        }
    }
    
    func getTextures(animation:Animation) -> [SKTexture]{
        switch animation{
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
            return enemy_1_main
        case .Enemy_2:
            return enemy_2_main
        case .Enemy_3:
            return enemy_3_main
        case .Enemy_4:
            return enemy_4_main
        case .Enemy_5:
            return enemy_5_main
        case .Enemy_6:
            return enemy_6_main
        case .Enemy_7:
            return enemy_7_main
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
      
 
        let bground_1_player_dir = Bundle.main.url(forResource: "begin", withExtension: "m4a", subdirectory: "Musics")
        
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
            let skCoinAction = SKAction.playSoundFileNamed("SoundEffects/getcoin.m4a", waitForCompletion: false)
            return skCoinAction
        case .Puff:
            let skPuffAction = SKAction.playSoundFileNamed("SoundEffects/puff.m4a", waitForCompletion: false)
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
    
    var mainAudio:AVAudio
    var account:AccountInfo
    var enemy:Enemy
    var boss:Enemy
   // var infobar:SKSpriteNode
    
    
    init(){
        debugMode = false
        mainAudio = AVAudio()
      //  infobar = SKSpriteNode()
        currentLevel = 0
        currentGold = 0
        currentHighscore = 0
        account = AccountInfo()
        enemy = Enemy(type: .Regular)
        boss = Enemy(type: .Boss)
        gamestate = .NoState
        
        // delegates
        enemy.delegate = self
        boss.delegate = self
    }

    func load(scene: SKScene) -> (Bool, String){
        
        mainScene = scene
    
       // load
        loadDebugVersion()
        
        // play background music
        mainAudio.play(type: .Background_Start)
        
        if !account.load(){return (false, "account error")}
        
         addChild(sknode: account.getCurrentToon().getNode())
        
        loadInfoBar()
        createWalls(leftXBound: 0, rightXBound:screenSize.width, width: 50, height: screenSize.height )
   
        account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.addChild(sknode: self.account.getCurrentToon().getBullet().shoot())
            }, SKAction.wait(forDuration: 0.1)])))
        
        return (true, "All Loaded")
    }
 
    func loadDebugVersion(){
        
        if debugMode == false{
            return
        }
        
        guard let scene = mainScene else {
            return
        }
        
        guard let infobar = scene.childNode(withName: "infobar") as? SKSpriteNode else{
            return
        }
        
        guard let toprightCorner = infobar.childNode(withName: "toprightCorner") as? SKSpriteNode else{
            print ("ERROR 000: Check Update() from Class GameInfo")
            return
        }
        
        infobar.color = .red
        toprightCorner.color = .green
        
    }
   
    
    func loadInfoBar(){
        
        func createGoldLabel(parentWidth:CGFloat, parentHeight:CGFloat) -> SKNode{
            
            let topright = SKSpriteNode()
            let width:CGFloat = 130
            let height:CGFloat = 30
            
            topright.color = .clear
            topright.name = "toprightCorner"
            topright.size = CGSize(width: width, height: height)
            topright.position = CGPoint(x: (parentWidth/2) - (width/2), y: parentHeight/2 - (height/2))
            
            // gold
            let curr = Currency(type: .Coin)
            
            let coinWidth:CGFloat = 25
            let coinHeight:CGFloat = 25
            let coinXpos = width/2 - coinWidth/2
            let coinYpos = height/2 - coinHeight/2
            
            let goldIcon = curr.createCoin(posX: coinXpos, posY: coinYpos, createPhysicalBody: false, animation: true)
            
            goldIcon.name = "stickerCoin"
            goldIcon.size = CGSize(width: coinWidth, height: coinHeight)
            goldIcon.position = CGPoint(x: coinXpos, y: coinYpos)
            
            topright.addChild(goldIcon)
            
            // text
            let labelYpos = -6

            let labelText = SKLabelNode(fontNamed: "Courier")
            labelText.text = "\(String(counter))"
            labelText.fontSize = 26
            labelText.fontColor = UIColor.brown
            labelText.horizontalAlignmentMode = .right
            labelText.position = CGPoint(x: 35, y:labelYpos)
            labelText.name = "coinCounter"
            topright.addChild(labelText)
            
            
            return topright
        }
        
        let infobar = SKSpriteNode()
        let width:CGFloat = screenSize.width
        let height:CGFloat = 100
        
        infobar.color = .clear
        infobar.name = "infobar"
        infobar.size = CGSize(width: width, height: height)
        infobar.position = CGPoint(x: 207, y: screenSize.height - (height/2))
        addChild(sknode: infobar)
        
        
        // adding gold
        infobar.addChild(createGoldLabel(parentWidth: width, parentHeight:height))
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
 
    func CallSpawnEnemy(scene: SKScene, totalWaves: Int){
        
        // update state
        updateGameState(state: .Spawning)
        
        // run action
        let spawningActionSequence = SKAction.sequence([SKAction.run {
            self.enemy.spawnEnemy()
            self.wavesForNextLevel -= 1
            }, SKAction.wait(forDuration: 3)])
        
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
  
        guard let toprightCorner = infobar.childNode(withName: "toprightCorner") as? SKSpriteNode else{
            print ("ERROR 000: Check Update() from Class GameInfo")
            return
        }
        
        guard let coinLabelText = toprightCorner.childNode(withName: "coinCounter") as? SKLabelNode else{
            print ("ERROR 001: Check Update() from Class GameInfo")
            return
        }
        
      //  enemy.getNode().maxHp = enemy.getNode().maxHp + 1
        
        if (gamestate == .NoState){
            // start enemy respawn
            wavesForNextLevel = randomInt(min: 5, max: 10)
            print(wavesForNextLevel)
            CallSpawnEnemy(scene: mainscene, totalWaves: wavesForNextLevel)
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









