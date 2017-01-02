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

enum SoundType{
    case Coin
    case Puff
}

class AVAudio {
    
    //private var audio
    private var coinPlayer:AVAudioPlayer
    private var puffPlayer:AVAudioPlayer
    private var skCoinAction:SKAction
    private var skPuffAction:SKAction
    init(){
        
        let coinDir = Bundle.main.url(forResource: "getcoin", withExtension: "m4a", subdirectory: "SoundEffects")
        let puffDir = Bundle.main.url(forResource: "puff", withExtension: "m4a", subdirectory: "SoundEffects")
        
        guard let coinSound = try? AVAudioPlayer(contentsOf: coinDir! as URL) else {
            fatalError("Failed to initialize the audio player coin")
        }
        guard let puffSound = try? AVAudioPlayer(contentsOf: puffDir! as URL) else{
            fatalError("Failed to initialize the audio player puff")
        }
        
        coinSound.volume = 1.0
        puffSound.volume = 1.0
        
        puffSound.prepareToPlay()
        coinSound.prepareToPlay()
        
        coinPlayer = coinSound
        puffPlayer = puffSound
        
        skCoinAction = SKAction.playSoundFileNamed("SoundEffects/getcoin.m4a", waitForCompletion: false)
        skPuffAction = SKAction.playSoundFileNamed("SoundEffects/puff.m4a", waitForCompletion: false)
        
    }
    
    func play(type: SoundType){
        switch type{
        case .Coin:
            coinPlayer.currentTime = 0
            coinPlayer.play()
        case .Puff:
            puffPlayer.currentTime = 0
            puffPlayer.play()
            
        }
    }
    
    func getAction(type: SoundType) -> SKAction{
        switch type{
        case .Coin:
            return skCoinAction
        case .Puff:
            return skPuffAction
            
        }
    }
    
    func load() -> Bool{
      
        return true
    }
    
    func createAudio(type: SoundType) -> SKAudioNode{
        switch type {
        case .Coin:
            let coinDir = "SoundEffects/getcoin.m4a"
            let coinAudio = SKAudioNode(fileNamed: coinDir)
            coinAudio.autoplayLooped = false
            coinAudio.name = "coin_sound"
            return coinAudio
        case .Puff:
            let puffDir = "SoundEffects/puff.m4a"
            let puffAudio = SKAudioNode(fileNamed: puffDir)
            puffAudio.autoplayLooped = false
            puffAudio.name = "puff_sound"
            return puffAudio
        }
        
        }
    }

class GameInfo: GameInfoDelegate{
    var counter:Int = 0 // only for debug - no purpose
    private var debugMode:Bool
    private var isLoadSuccessfull:Bool
    
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
    var infobar:SKSpriteNode
    
    
    init(){
        
        debugMode = false
        mainAudio = AVAudio()
        infobar = SKSpriteNode()
        currentLevel = 0
        currentGold = 0
        currentHighscore = 0
        account = AccountInfo()
        enemy = Enemy(type: .Regular)
        boss = Enemy(type: .Boss)
        isLoadSuccessfull = false
        gamestate = .NoState
        
        enemy.delegate = self
        boss.delegate = self
        
    }

    func load(scene: SKScene) -> (Bool, String){
        
        mainScene = scene

        
        
        // load
        loadDebugVersion()
        
        if !account.load(){return (false, "account error")}
        if !enemy.load(){return (false, "enemy error")}
        if !boss.load(){return (false, "boss error")}
        
        loadInfoBar()
        createWalls(leftXBound: 0, rightXBound:screenSize.width, width: 50, height: screenSize.height )
        // add
        addChild(sknode: account.getCurrentToon().getNode())
        addChild(sknode: mainAudio.createAudio(type: .Coin))
        addChild(sknode: mainAudio.createAudio(type: .Puff))
        
        // add action for Toon ( shoot )
        account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.addChild(sknode: self.account.getCurrentToon().getBullet().shoot())
            }, SKAction.wait(forDuration: 0.1)])))
        
        isLoadSuccessfull = true
        return (isLoadSuccessfull, "All Loaded")
    }
    
    func loadDebugVersion(){
        
        if debugMode == false{
            return
        }
        guard let toprightCorner = self.infobar.childNode(withName: "toprightCorner") as? SKSpriteNode else{
            print ("ERROR 000: Check Update() from Class GameInfo")
            return
        }
        
        /*guard let coinLabelText = toprightCorner.childNode(withName: "coinCounter") as? SKLabelNode else{
            print ("ERROR 001: Check Update() from Class GameInfo")
            return
        }*/
        
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
        
        guard let toprightCorner = self.infobar.childNode(withName: "toprightCorner") as? SKSpriteNode else{
            print ("ERROR 000: Check Update() from Class GameInfo")
            return
        }
        
        guard let coinLabelText = toprightCorner.childNode(withName: "coinCounter") as? SKLabelNode else{
            print ("ERROR 001: Check Update() from Class GameInfo")
            return
        }
        
      //  enemy.getNode().maxHp = enemy.getNode().maxHp + 1
        
      //  print(enemy.getNode().maxHp)
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
      //  print("called addChild")
      //  delegate?.addChild(sknode: sknode)
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

class AccountInfo{
    
    struct Bag{
        var something:Int
        
        init(){
            something = 0
        }
    }
    
    private var level:Int
    private var currentToonIndex:Int
    private var characters:[Toon]
    private var gold:Int
    private var experience:CGFloat
    private var highscore:Int
    var inventory:Bag
    
    init(){
        level = 0
        currentToonIndex = 0
        inventory = Bag()
        gold = 0
        experience = 0.0
        characters = [Toon(w: 180, h: 130)]
        highscore = 0
        characters[0].load()
        
    }
    
    func load() -> Bool{
        
        
        
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
        }
        
        return true
    }
    
    
    func getCurrentToon() -> Toon{
        return characters[currentToonIndex]
    }
    
    
    
    
    
}



class Highscore{
    
}


class Toon{

    private var width:CGFloat
    private var height:CGFloat
    private var node:SKSpriteNode
    private var bullet:Projectile
    
    private var actions:[SKTexture]
    
    init(w:CGFloat, h:CGFloat){
      
        node = SKSpriteNode(imageNamed: "\(PLAYER_SPRITES_DIR)/Toon1/main.png")
        width = w
        height = h
        node.color = SKColor.blue
        node.size = CGSize(width: w, height: h)
        node.position = CGPoint(x: 200, y: 100)
        node.name = "toon"
        
        actions = [SKTexture(imageNamed: "\(PLAYER_SPRITES_DIR)/Toon1/action1"), SKTexture(imageNamed: "\(PLAYER_SPRITES_DIR)/Toon1/action2"), SKTexture(imageNamed: "\(PLAYER_SPRITES_DIR)/Toon1/action3"), SKTexture(imageNamed: "\(PLAYER_SPRITES_DIR)/Toon1/action4")]
        
        bullet = Projectile(posX: node.position.x, posY: node.position.y)
    }
    
    func load(){
        
          node.run(SKAction.repeatForever(SKAction.animate(with: actions, timePerFrame: 0.05)))
        
        //node.physicsBody =  SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width/4, height: node.size.height/2))
        node.physicsBody!.isDynamic = true // allow physic simulation to move it
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.allowsRotation = false // not allow it to rotate
       // node.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        node.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
    }
    
    func getNode() -> SKSpriteNode{
        return node
    }
    
    func changeSize(w:CGFloat, h:CGFloat){
        width = w
        height = h
    }
    

    func updateProjectile(){
        //print ("new bullet position", node.position.x)
        bullet.setPosX(x: node.position.x)
     
    }
    
    func getBullet() -> Projectile{
        return bullet
    }
    
    }


struct Projectile {
    var originX:CGFloat
    var originY:CGFloat
    var power:CGFloat
    var spriteName = "bullet.png"
    var name = "bullet"
    var bulletType:ProjectileType
    var size = CGSize(width: 30.0, height: 30.0)
    
    init (posX:CGFloat, posY:CGFloat){
        originX = posX
        originY = posY + 35
        
        // constant for now
        
        power = 25.0
        bulletType = .type1
    }
    
    func shoot() -> SKNode{
        
        let bullet = SKSpriteNode(imageNamed: spriteName)
        bullet.userData = NSMutableDictionary()
        bullet.name = name
        bullet.position = CGPoint(x: originX, y: originY)
        bullet.size = size
        
        bullet.power = self.power
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody!.isDynamic = true
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.allowsRotation = false
        
        bullet.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        bullet.physicsBody!.collisionBitMask = 0
        bullet.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        bullet.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.update(n: bullet)}),
                SKAction.wait(forDuration: TimeInterval(0.01))])
        ), withKey: "shooting")
        
    return bullet
    }
    mutating func setPosX(x:CGFloat){
        originX = x
    }
    
    mutating func setPosY(y:CGFloat){
        originY = y + 35
    }
    
    func update(n:SKSpriteNode){
        n.run(SKAction.moveBy(x: 0, y: 6, duration: 0.01))
        n.run(SKAction.scale(to: 5, duration: 0.48))
        if n.position.y > 740.0{
            n.removeAllActions()
            n.removeFromParent()
        }
    }
}








