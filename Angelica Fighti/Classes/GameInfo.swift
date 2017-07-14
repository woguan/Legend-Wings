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
    
    // Main Variables
    weak fileprivate var mainScene:SKScene?
    fileprivate var account:AccountInfo
    fileprivate var currentLevel:Int
    fileprivate var currentGold:Int  // tracking local current in-game
    fileprivate var currentHighscore:Int
    fileprivate var timer:Timer?
    fileprivate let infobar:Infobar
    
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
        infobar = Infobar(name: "infobar")
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
        
        // update infobar
        infobar.updateGoldBalnceLabel(balance: account.getGoldBalance())
        addChild(infobar)
        
        loadStatus = self.createWalls(leftXBound: 0, rightXBound:screenSize.width, width: 50, height: screenSize.height)
        
        return loadStatus
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
    
    //  Only called when the gamestate is spawning. 
    //  This function is called every second.
    
    @objc private func running(){
        let random = randomInt(min: 0, max: 100)
        // Fireball
        if random < 10 {
          //  print("Fireball called with random: ", random)
            fireball_enemy.spawn(scene: mainScene!)
        }
        
    }
    
    private func updateGameState(){
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check updateGameState() from GameInfo")
            return
        }
        
        switch gamestate {
        case .Start:
                // Load Map
                map = Map(maps: global.getTextures(textures: .Map_Ragnarok), scene: mainscene)

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
                infobar.fadeAway()
                
                mainscene.run(SKAction.sequence([SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "0"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "1"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "2"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "3")]))
                
                mainscene.run(SKAction.sequence([buildingsAction, SKAction.wait(forDuration: 3), SKAction.run{self.changeGameState(.Spawning)
                    }, SKAction.wait(forDuration: 0.2), SKAction.run { self.account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([SKAction.run {

                        self.addChild(self.account.getCurrentToon().getBullet().shoot())
                        }, SKAction.wait(forDuration: 0.06)])))
                    }]))
        case .WaitingState:
            regular_enemies.increaseDifficulty()
            fireball_enemy.increaseDifficulty()
            boss.increaseDifficulty()
            self.changeGameState(.Spawning)
        case .Spawning:
            print("Spawning")
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(running), userInfo: nil, repeats: true)
            
            wavesForNextLevel = randomInt(min: 5, max: 10)
            
            let action = SKAction.sequence([SKAction.run({
                self.regular_enemies.spawn(scene: mainscene)
            }), SKAction.wait(forDuration: 3)])
            
            //totalWaves
            //wavesForNextLevel
            let spawnAction = SKAction.repeat(action, count: wavesForNextLevel)
            let endAction = SKAction.run(didFinishSpawningEnemy)
            
            mainscene.run(SKAction.sequence([spawnAction, endAction]))
            
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
    
    internal func requestCurrentToonIndex() -> Int{
        return account.getCurrentToonIndex()
    }
    
    internal func getCurrentToonBullet() -> Projectile{
        return account.getCurrentToon().getBullet()
    }
    
    internal func getToonBulletEmmiterNode(x px:CGFloat, y py:CGFloat) -> SKEmitterNode{
        return account.getCurrentToon().getBullet().generateTouchedEnemyEmmiterNode(x: px, y: py)
    }
    internal func requestChangeToon(index: Int){
        self.account.selectToonIndex(index: index)
    }
    internal func requestToonDescription(index id:Int) -> [String]{
        return self.account.getToonDescriptionByIndex(index: id)
    }
    
    internal func requestToonName(index id:Int) -> String{
        return self.account.getNameOfToonByIndex(index: id)
    }
    
    internal func requestToonTitle(index id:Int) -> String{
        return self.account.getTitleOfToonByIndex(index: id)
    }
    
    internal func requestToonBulletLevel(index id:Int) -> Int{
        return self.account.getBulletLevelOfToonByIndex(index: id)
    }
    
    internal func requestUpgradeBullet() -> (Bool, String){
        let (success, response) = self.account.upgradeBullet()
        
        if success {
            self.infobar.updateGoldBalnceLabel(balance: self.account.getGoldBalance())
        }
        return (success, response)
    }
    
    internal func prepareToChangeScene(){
        boss.delegate = nil
        regular_enemies.delegate = nil
        fireball_enemy.delegate = nil
        mainAudio.stop()
        map?.prepareToChangeScene()
        timer?.invalidate()
    }
    
    // Maybe change this later to something like:
    // Enum CurrencyType: .Gold, .Diamond... etc
    internal func addCoin(amount:Int){
        currentGold += amount
        infobar.updateGoldLabel(coinCount: self.currentGold)
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
    }
    
}
