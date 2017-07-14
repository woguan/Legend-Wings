//
//  Global.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 6/2/17.
//  Copyright © 2017 Wong. All rights reserved.


/*
 
 This class is used to access all sprites/textures.
 This class should not be deinitiated after switching scenes
 
 */

import Foundation
import SpriteKit
import AVFoundation
import ObjectiveC


class Global {
    
    deinit {
        print ("Global is deinitiated")
    }
    
    static let sharedInstance = Global()
    
    enum Animation{
        case Boss_1_Dead_Animation
        case Boss_1_Move_Animation
        case Puff_Animation
        case Gold_Animation
        case Map_Ragnarok
        case Fireball_Aura
        case Fireball_Face
        case Fireball_Smoke
        case Regular_Redder_Sprites
        case Regular_Grenner_Sprites
        case Regular_Purpler_Sprites
        case Regular_Bluer_Sprites
    }
    
    enum Main:String{
        
        // Characters
        case Character_Alpha
        case Character_Alpha_Wing
        case Character_Alpha_Projectile_1
        case Character_Alpha_Projectile_2
        case Character_Alpha_Projectile_3
        case Character_Alpha_Projectile_4
        case Character_Alpha_Projectile_5
        case Character_Alpha_Bullet_Level_1
        
        case Character_Beta
        case Character_Beta_Wing
        case Character_Beta_Projectile_1
        case Character_Beta_Projectile_2
        case Character_Beta_Projectile_3
        case Character_Beta_Projectile_4
        case Character_Beta_Projectile_5
        
        case Character_Celta
        case Character_Celta_Wing
        case Character_Celta_Projectile_1
        case Character_Celta_Projectile_2
        case Character_Celta_Projectile_3
        case Character_Celta_Projectile_4
        case Character_Celta_Projectile_5
        
        case Character_Delta
        case Character_Delta_Wing
        case Character_Delta_Projectile_1
        case Character_Delta_Projectile_2
        case Character_Delta_Projectile_3
        case Character_Delta_Projectile_4
        case Character_Delta_Projectile_5
        
        // Main Menu
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
        
        // Character Scene Menu
        case Character_Menu_Alpha
        case Character_Menu_Beta
        case Character_Menu_Celta
        case Character_Menu_Delta
        case Character_Menu_BackArrow = "character_menu_backarrow"
        case Character_Menu_LeftArrow = "character_menu_leftarrow"
        case Character_Menu_RightArrow = "character_menu_rightarrow"
        case Character_Menu_TitleMenu
        case Character_Menu_MessageBox = "character_menu_messagebox"
        case Character_Menu_Background
        case Character_Menu_GreenButton = "character_menu_greenbutton"
        case Character_Menu_BlueButton = "character_menu_bluebutton"
        case Character_Menu_CharacterNameBar
        case Character_Menu_Badge
        case Character_Menu_GlowingEffect = "character_menu_glowingeffect"
        case Character_Menu_GroundEffect = "character_menu_groundeffect"
        case Character_Menu_UpgradeBox = "character_menu_upgradebox"
        case Character_Menu_UpgradeArrow = "character_menu_upgradearrow"
        case Character_Menu_UpgradeIcon = "character_menu_upgradeicon"
        case Character_Menu_UpgradeIconShade = "character_menu_upgradeiconshade"
        case Character_Menu_UpgradeCloseButton = "character_menu_upgradeclosebutton"
        case Character_Menu_UpgradeGreenButton = "character_menu_upgradegreenbutton"
        
        // Bosses
        case Boss_1 = "boss_1"
        
        case Boss_Pinky_Body
        case Boss_Pinky_Bone
        case Boss_Pinky_Skull
        case Boss_Pinky_Left_Ear
        case Boss_Pinky_Right_Ear
        case Boss_Pinky_Left_EyeBrow
        case Boss_Pinky_Right_EyeBrow
        case Boss_Pinky_Left_Damaged_Eye
        case Boss_Pinky_Right_Damaged_Eye
        case Boss_Pinky_Left_Eye
        case Boss_Pinky_Right_Eye
        case Boss_Pinky_Left_Wing
        case Boss_Pinky_Right_Wing
        case Boss_Pinky_Left_Flipped_Wing
        case Boss_Pinky_Right_Flipped_Wing
        case Boss_Pinky_Left_Middle_Wing
        case Boss_Pinky_Right_Middle_Wing
        
        // Rest
        case Gold
        case Enemy_1
        case Enemy_2
        case Enemy_3
        case Enemy_4
        case Enemy_5
        case Enemy_6
        case Enemy_7
        case StartCloud_1 = "startcloud_1"
        case StartCloud_2 = "startcloud_2"
        case Fireball_Tracker
        
        
    }
    
    enum HUD{
        case Gold
        case Trophy
    }
    enum BossAttack{
        case Boss1_type_1
    }
    
    private enum FireballType{
        case Face
        case Aura
        case Smoke
        case Tracker
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
    
    enum ClassicBoss{
        case Bomber
    }
    enum ClassicBossTexture{
        case mainTexture
        case attackTexture
        case dieAnimation
        case moveAnimation
    }
    
    enum Regular{
        case Redder
        case Grenner
        case Bluer
        case Purpler
    }
    enum Boss{
        case Pinky
    }
    
    // Temporary variables to hold textures -> Find a better approach
    private var gold_main:SKTexture!
    private var gold_animation:[SKTexture] = []
    private var bullet:SKTexture!
    
    // Enemies
    private var boss = [Boss:[SKTexture]]()
    private var classicBoss = [ClassicBoss:[ClassicBossTexture:[SKTexture]]]()
    private var regularEnemy = [Regular:[SKTexture]]()
    private var fireball_enemy_collection = [FireballType:[SKTexture]]()
    private var puff_regular_animation:[SKTexture] = []
    private var enemy_main_collection = [SKTexture]()
    
    // Scenes
    private var main_menu_collection = [MainMenu:[SKTexture]]() // All Sprites used in Main Menu
    private var character_menu_collection = [SKTexture]() // Sprites used in Character Selection Scene
    private var start_cloud:[SKTexture] = []
    private var map = [MapType:[SKTexture]]()
    private var purple_button:SKTexture!
    private var gold_hud:[SKTexture] = []
    
    // Characters
    private var character_sprite:[(SKTexture, SKTexture)] = []
    private var character_projectiles:[[SKTexture]?] = []
    
    // ETC
    private var isSetUp:Bool = false
    private let availableCharacters = 4
    private var totalFilesToLoad:Int = 7
    private var currentFilesLoaded:Int = 0
    private var serialQueue:DispatchQueue
    
    private init (){
        
        serialQueue = DispatchQueue(label: "SerialLoadQueue")
        
        self.map[.Ragnarok] = []
        
        self.main_menu_collection[.Background] = []
        self.main_menu_collection[.Building] = []
        self.main_menu_collection[.Waterfall] = []
        self.main_menu_collection[.Smoke] = []
        self.main_menu_collection[.Level] = []
        self.main_menu_collection[.Currency] = []
        self.main_menu_collection[.Text] = []
        
        self.fireball_enemy_collection[.Face] = []
        self.fireball_enemy_collection[.Aura] = []
        self.fireball_enemy_collection[.Tracker] = []
        self.fireball_enemy_collection[.Smoke] = []
        
        self.classicBoss[.Bomber] = [:]
        self.classicBoss[.Bomber]![.attackTexture] = []
        self.classicBoss[.Bomber]![.dieAnimation] = []
        self.classicBoss[.Bomber]![.mainTexture] = []
        self.classicBoss[.Bomber]![.moveAnimation] = []
        
        self.boss[.Pinky] = []
        
        self.regularEnemy[.Redder] = []
        self.regularEnemy[.Grenner] = []
        self.regularEnemy[.Bluer] = []
        self.regularEnemy[.Purpler] = []
        
        for _ in 0..<availableCharacters{
            character_projectiles.append(nil)
        }
    }
    
    func prioirityLoad(){
        
        if isSetUp {
            print("Warning: Loaded Previously.")
            return
        }
        
        isSetUp = true // Make sure this function is called only once.
        
        // Order:  mapPreload -> enemyPreload -> playerPreload -> itemsPreload
        // -> hudPreload -> characterScenePreload  mainMenuPreload ->|| total: 7
        self.mapPreload()
        self.enemyPreload()
        self.playerPreload()
        self.itemsPreload()
        self.hudPreload()
        self.characterScenePreload()
        self.mainMenuPreload()
    }
    
    
    private func mainMenuPreload(){
        
        let atlas = SKTextureAtlas(named: "mainmenu")
        atlas.preload {
            self.purple_button = atlas.textureNamed("PurpleButton")
            
            for texture in atlas.textureNames{
                
                if texture.contains("main_menu_") && texture.contains("background"){
                    self.main_menu_collection[.Background]!.append(atlas.textureNamed("main_menu_background_\(self.main_menu_collection[.Background]!.count + 1)"))
                }
                else if texture.contains("main_menu_") && texture.contains("building"){
                    self.main_menu_collection[.Building]!.append(atlas.textureNamed("main_menu_building_\(self.main_menu_collection[.Building]!.count + 1)"))
                }
                else if texture.contains("main_menu_") && texture.contains("waterfall"){
                    self.main_menu_collection[.Waterfall]!.append(atlas.textureNamed("main_menu_waterfall_\(self.main_menu_collection[.Waterfall]!.count + 1)"))
                }
                else if texture.contains("main_menu_") && texture.contains("level"){
                    self.main_menu_collection[.Level]!.append(atlas.textureNamed("main_menu_level_\(self.main_menu_collection[.Level]!.count + 1)"))
                }
                else if texture.contains("main_menu_") && texture.contains("currency"){
                    self.main_menu_collection[.Currency]!.append(atlas.textureNamed("main_menu_currency_\(self.main_menu_collection[.Currency]!.count + 1)"))
                }
                else if texture.contains("main_menu_") && texture.contains("text"){
                    self.main_menu_collection[.Text]!.append(atlas.textureNamed("main_menu_text_\(self.main_menu_collection[.Text]!.count + 1)"))
                }
                else if texture.contains("start_cloud_"){
                    self.start_cloud.append(atlas.textureNamed("start_cloud_\(self.start_cloud.count + 1)"))
                }
                
            }
            
            self.checkmark()
        }
        
    }
    
    private func mapPreload(){
        let atlas = SKTextureAtlas(named: "Map")
        atlas.preload {
            for texture in atlas.textureNames{
                if texture.contains("map1_"){
                    self.map[.Ragnarok]!.append(atlas.textureNamed("map1_\(self.map[.Ragnarok]!.count + 1)"))
                    print(texture)
                }
            }
            self.checkmark()
        }
    }
    
    private func enemyPreload(){
        let atlas = SKTextureAtlas(named: "Enemy")
        
        atlas.preload {
            self.classicBoss[.Bomber]![.mainTexture]!.append(atlas.textureNamed("boss-1-main"))
            self.classicBoss[.Bomber]![.attackTexture]!.append(atlas.textureNamed("enemy_attack_ball"))
            
            for texture in atlas.textureNames{
                if texture.contains("enemy") && texture.contains("main"){
                    self.enemy_main_collection.append(atlas.textureNamed("enemy_\(self.enemy_main_collection.count+1)_main"))
                }
                    
                else if texture.contains("boss_1_movement"){
                    let csize = self.classicBoss[.Bomber]![.moveAnimation]!.count
                    self.classicBoss[.Bomber]![.moveAnimation]!.append(atlas.textureNamed("boss_1_movement\(csize + 1)"))
                }
                    
                else if texture.contains("boss_1_die"){
                    let csize = self.classicBoss[.Bomber]![.dieAnimation]!.count
                    self.classicBoss[.Bomber]![.dieAnimation]!.append(atlas.textureNamed("boss_1_die\(csize + 1)"))
                }
                else if texture.contains("enemy_fireball_"){
                    if texture.contains("aura"){
                        self.fireball_enemy_collection[.Aura]!.append(atlas.textureNamed("enemy_fireball_aura_\(self.fireball_enemy_collection[.Aura]!.count + 1)"))
                    }
                    else if texture.contains("face"){
                        self.fireball_enemy_collection[.Face]!.append(atlas.textureNamed("enemy_fireball_face_\(self.fireball_enemy_collection[.Face]!.count + 1)"))
                    }
                    else if texture.contains("tracker"){
                        self.fireball_enemy_collection[.Tracker]!.append(atlas.textureNamed("enemy_fireball_tracker_\(self.fireball_enemy_collection[.Tracker]!.count + 1)"))
                    }
                    else if texture.contains("smoke"){
                        self.fireball_enemy_collection[.Smoke]!.append(atlas.textureNamed("enemy_fireball_smoke_\(self.fireball_enemy_collection[.Smoke]!.count + 1)"))
                    }
                }
                else if texture.contains("puff_regular"){
                    self.puff_regular_animation.append(atlas.textureNamed("puff_regular\(self.puff_regular_animation.count + 1)"))
                }
                else if texture.contains("boss_2_sprite"){
                    self.boss[.Pinky]!.append(atlas.textureNamed("boss_2_sprite\(self.boss[.Pinky]!.count + 1)"))
                }
                else if texture.contains("enemy_red_"){
                    
                    self.regularEnemy[.Redder]!.append(atlas.textureNamed("enemy_red_\(self.regularEnemy[.Redder]!.count + 1)"))
                }
                else if texture.contains("enemy_green_"){
                    
                    self.regularEnemy[.Grenner]!.append(atlas.textureNamed("enemy_green_\(self.regularEnemy[.Grenner]!.count + 1)"))
                }
                else if texture.contains("enemy_blue_"){
                    
                    self.regularEnemy[.Bluer]!.append(atlas.textureNamed("enemy_blue_\(self.regularEnemy[.Bluer]!.count + 1)"))
                }
                else if texture.contains("enemy_purple_"){
                    
                    self.regularEnemy[.Purpler]!.append(atlas.textureNamed("enemy_purple_\(self.regularEnemy[.Purpler]!.count + 1)"))
                }
                
            }
            self.checkmark()
        }
    }
    
    private func playerPreload(){
        let atlas = SKTextureAtlas(named: "Player")
        atlas.preload {
            for texture in atlas.textureNames{
                if texture.contains("toon_") && texture.contains("_main"){
                    let count = self.character_sprite.count + 1
                    let dt = (atlas.textureNamed("toon_\(count)_main"), atlas.textureNamed("toon_\(count)_wing"))
                    self.character_sprite.append(dt)
                }
                    
                else if texture.contains("toon_1") && texture.contains("projectile"){
                    let id = 0
                    if self.character_projectiles[id] == nil{
                        self.character_projectiles[id] = []
                    }
                    self.character_projectiles[id]!.append(atlas.textureNamed("toon_1_projectile_type_\(self.character_projectiles[id]!.count + 1)"))
                }
                else if texture.contains("toon_2") && texture.contains("projectile"){
                    let id = 1
                    if self.character_projectiles[id] == nil{
                        self.character_projectiles[id] = []
                    }
                    self.character_projectiles[id]!.append(atlas.textureNamed("toon_2_projectile_type_\(self.character_projectiles[id]!.count + 1)"))
                }
                else if texture.contains("toon_3") && texture.contains("projectile"){
                    let id = 2
                    if self.character_projectiles[id] == nil{
                        self.character_projectiles[id] = []
                    }
                    self.character_projectiles[id]!.append(atlas.textureNamed("toon_3_projectile_type_\(self.character_projectiles[id]!.count + 1)"))
                }
                else if texture.contains("toon_4") && texture.contains("projectile"){
                    let id = 3
                    if self.character_projectiles[id] == nil{
                        self.character_projectiles[id] = []
                    }
                    self.character_projectiles[id]!.append(atlas.textureNamed("toon_4_projectile_type_\(self.character_projectiles[id]!.count + 1)"))
                }
                
            }
            self.checkmark()
        }
    }
    
    private func itemsPreload(){
        
        let atlas = SKTextureAtlas(named: "Items")
        
        atlas.preload {
            self.bullet = atlas.textureNamed("bulletLater")
            self.gold_main = atlas.textureNamed("gold_main")
            
            for texture in atlas.textureNames{
                if texture.contains("gold_action"){
                    self.gold_animation.append(atlas.textureNamed("gold_action\(self.gold_animation.count + 1)"))
                }
            }
            self.checkmark()
        }
        
    }
    
    private func hudPreload(){
        let atlas = SKTextureAtlas(named: "HUD")
        
        atlas.preload {
            
            for texture in atlas.textureNames{
                if texture.contains("hud_gold"){
                    self.gold_hud.append(atlas.textureNamed("hud_gold_\(self.gold_hud.count)"))
                }
            }
            
            self.checkmark()
            
        }
    }
    
    private func characterScenePreload(){
        let atlas = SKTextureAtlas(named: "CharacterScene")
        
        atlas.preload {
            for texture in atlas.textureNames{
                if texture.contains("character_menu_"){
                    self.character_menu_collection.append(atlas.textureNamed("character_menu_\(self.character_menu_collection.count + 1)"))
                }
            }
            self.checkmark()
        }
    }
    
    private func checkmark(){
        
        self.serialQueue.async {
            
            let nc = NotificationCenter.default
            
            // Checkmark
            self.currentFilesLoaded += 1 // Increase Loaded File
            //print("loaded: ", self.currentFilesLoaded)
            let left:Int = Int((CGFloat(self.currentFilesLoaded)/CGFloat(self.totalFilesToLoad)) * 100.0)
            
            DispatchQueue.main.async {
                nc.post(name: Notification.Name("ProgressNotification"), object: nil, userInfo: ["Left":left])
            }
            
            // Send Notification if all loaded
            if self.currentFilesLoaded == self.totalFilesToLoad {
                let nfname = Notification.Name("PreloadNotification")
                
                DispatchQueue.main.async {
                    nc.post(name: nfname, object: nil, userInfo: nil)
                }
            }
        }
        
    }
    
    internal func getHUDTexture(hudType:HUD, text:String) -> SKTexture{
        
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
    
    internal func getTextures(textures:Animation) -> [SKTexture]{
        switch textures{
        case .Boss_1_Dead_Animation:
            return classicBoss[.Bomber]![.dieAnimation]!
        case .Boss_1_Move_Animation:
            return self.classicBoss[.Bomber]![.moveAnimation]!
        case .Gold_Animation:
            return gold_animation
        case .Puff_Animation:
            return puff_regular_animation
        case .Map_Ragnarok:
            return map[.Ragnarok]!
        case .Fireball_Face:
            return fireball_enemy_collection[.Face]!
        case .Fireball_Aura:
            return fireball_enemy_collection[.Aura]!
        case .Fireball_Smoke:
            return fireball_enemy_collection[.Smoke]!
        case .Regular_Redder_Sprites:
            return self.regularEnemy[.Redder]!
        case .Regular_Grenner_Sprites:
            return self.regularEnemy[.Grenner]!
        case .Regular_Bluer_Sprites:
            return self.regularEnemy[.Bluer]!
        case .Regular_Purpler_Sprites:
            return self.regularEnemy[.Purpler]!
        }
        
    }
    internal func getMainTexture(main: Main) -> SKTexture{
        switch main{
            
        // Main Menu
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
            
        // Characters
        case .Character_Alpha:
            return self.character_sprite[0].0
        case .Character_Alpha_Wing:
            return self.character_sprite[0].1
        case .Character_Alpha_Bullet_Level_1:
            return bullet
        case .Character_Alpha_Projectile_1:
            return character_projectiles[0]![0]
        case .Character_Alpha_Projectile_2:
            return character_projectiles[0]![1]
        case .Character_Alpha_Projectile_3:
            return character_projectiles[0]![2]
        case .Character_Alpha_Projectile_4:
            return character_projectiles[0]![3]
        case .Character_Alpha_Projectile_5:
            return character_projectiles[0]![4]
            
        case .Character_Beta:
            return self.character_sprite[1].0
        case .Character_Beta_Wing:
            return self.character_sprite[1].1
        case .Character_Beta_Projectile_1:
            return character_projectiles[1]![0]
        case .Character_Beta_Projectile_2:
            return character_projectiles[1]![1]
        case .Character_Beta_Projectile_3:
            return character_projectiles[1]![2]
        case .Character_Beta_Projectile_4:
            return character_projectiles[1]![3]
        case .Character_Beta_Projectile_5:
            return character_projectiles[1]![4]
            
        case .Character_Celta:
            return self.character_sprite[2].0
        case .Character_Celta_Wing:
            return self.character_sprite[2].1
        case .Character_Celta_Projectile_1:
            return character_projectiles[2]![0]
        case .Character_Celta_Projectile_2:
            return character_projectiles[2]![1]
        case .Character_Celta_Projectile_3:
            return character_projectiles[2]![2]
        case .Character_Celta_Projectile_4:
            return character_projectiles[2]![3]
        case .Character_Celta_Projectile_5:
            return character_projectiles[2]![4]
            
        case .Character_Delta:
            return character_sprite[3].0
        case .Character_Delta_Wing:
            return character_sprite[3].1
        case .Character_Delta_Projectile_1:
            return character_projectiles[3]![0]
        case .Character_Delta_Projectile_2:
            return character_projectiles[3]![1]
        case .Character_Delta_Projectile_3:
            return character_projectiles[3]![2]
        case .Character_Delta_Projectile_4:
            return character_projectiles[3]![3]
        case .Character_Delta_Projectile_5:
            return character_projectiles[3]![4]
            
            
        // Character Menu Scene
        case .Character_Menu_Alpha:
            return self.character_menu_collection[0]
        case .Character_Menu_Beta:
            return self.character_menu_collection[1]
        case .Character_Menu_Celta:
            return self.character_menu_collection[2]
        case .Character_Menu_Delta:
            return self.character_menu_collection[3]
        case .Character_Menu_BackArrow:
            return self.character_menu_collection[4]
        case .Character_Menu_LeftArrow:
            return self.character_menu_collection[5]
        case .Character_Menu_RightArrow:
            return self.character_menu_collection[6]
        case .Character_Menu_TitleMenu:
            return self.character_menu_collection[7]
        case .Character_Menu_MessageBox:
            return self.character_menu_collection[8]
        case .Character_Menu_Background:
            return self.character_menu_collection[9]
        case .Character_Menu_GreenButton:
            return self.character_menu_collection[10]
        case .Character_Menu_BlueButton:
            return self.character_menu_collection[11]
        case .Character_Menu_CharacterNameBar:
            return self.character_menu_collection[12]
        case .Character_Menu_Badge:
            return self.character_menu_collection[13]
        case .Character_Menu_GlowingEffect:
            return self.character_menu_collection[14]
        case .Character_Menu_GroundEffect:
            return self.character_menu_collection[15]
        case .Character_Menu_UpgradeBox:
            return self.character_menu_collection[16]
        case .Character_Menu_UpgradeArrow:
            return self.character_menu_collection[17]
        case .Character_Menu_UpgradeIcon:
            return self.character_menu_collection[18]
        case .Character_Menu_UpgradeIconShade:
            return self.character_menu_collection[19]
        case .Character_Menu_UpgradeCloseButton:
            return self.character_menu_collection[20]
        case .Character_Menu_UpgradeGreenButton:
            return self.character_menu_collection[21]
            
        // Boss
        case .Boss_1:
            return classicBoss[.Bomber]![.mainTexture]![0]
        case .Boss_Pinky_Body:
            return self.boss[.Pinky]![0]
        case .Boss_Pinky_Bone:
            return self.boss[.Pinky]![1]
        case .Boss_Pinky_Skull:
            return self.boss[.Pinky]![2]
        case .Boss_Pinky_Right_Ear:
            return self.boss[.Pinky]![3]
        case .Boss_Pinky_Left_Ear:
            return self.boss[.Pinky]![4]
        case .Boss_Pinky_Left_EyeBrow:
            return self.boss[.Pinky]![5]
        case .Boss_Pinky_Right_EyeBrow:
            return self.boss[.Pinky]![6]
        case .Boss_Pinky_Right_Damaged_Eye:
            return self.boss[.Pinky]![8]
        case .Boss_Pinky_Left_Damaged_Eye:
            return self.boss[.Pinky]![7]
        case .Boss_Pinky_Left_Eye:
            return self.boss[.Pinky]![9]
        case .Boss_Pinky_Right_Eye:
            return self.boss[.Pinky]![10]
        case .Boss_Pinky_Left_Wing:
            return self.boss[.Pinky]![11]
        case .Boss_Pinky_Right_Wing:
            return self.boss[.Pinky]![12]
        case .Boss_Pinky_Left_Flipped_Wing:
            return self.boss[.Pinky]![13]
        case .Boss_Pinky_Right_Flipped_Wing:
            return self.boss[.Pinky]![14]
        case .Boss_Pinky_Left_Middle_Wing:
            return self.boss[.Pinky]![15]
        case .Boss_Pinky_Right_Middle_Wing:
            return self.boss[.Pinky]![16]
            
        // Rest
        case .Gold:
            return gold_main
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
        case .StartCloud_1:
            return start_cloud[0]
        case .StartCloud_2:
            return start_cloud[1]
        case .Fireball_Tracker:
            return fireball_enemy_collection[.Tracker]![0]
        }
    }
    
    internal func getAttackTexture(attack: BossAttack) -> SKTexture{
        switch (attack){
        case .Boss1_type_1:
            return classicBoss[.Bomber]![.attackTexture]![0]
        }
    }
    
}

let global:Global = Global.sharedInstance // Using this Singleton to access all textures


