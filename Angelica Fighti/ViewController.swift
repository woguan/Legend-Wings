//
//  ViewController.swift
//  Angelica Fighti
//
//  Created by Guan Wong on 12/22/16.
//  Copyright © 2016 Wong. All rights reserved.
//

import UIKit
import SpriteKit

let screenSize: CGRect = UIScreen.main.bounds

class ViewController: UIViewController {
    
    enum LoadStatus{
        case Normal
        case Warning
        case Critical
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get user storage directory
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
               // append it with the plist we created
        let fullPathName = documentDir.appendingPathComponent("userinfo.plist")
        guard let sourceFilePath = Bundle.main.path(forResource: "userinfo", ofType: "plist") else{
            redirect(status: .Critical, message: "Critical001:: userinfo.plist is missing. Please, add it to the main path")
            return
        }
        
        guard let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath) else{
            redirect(status: .Critical, message: "Critical002: Error loading contents of  \(fullPathName)")
            return
        }
        
        // load the contents into a variable
        guard let virtualPList = NSMutableDictionary(contentsOfFile: fullPathName) else{
            
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: fullPathName){
                // savingx
                if !originalPlist.write(toFile: fullPathName, atomically: false){
                    redirect(status: .Critical, message: "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController")
                }
            }
            redirect(status: .Warning, message: "[Notice]: OriginalPlist being used.")
            return
        }
        
        // this variable will check if the plist is already in user's storage path
        redirect(status: .Normal, message: "Success")
        print ("VirtualPlist exists: ", virtualPList)
        
        
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func redirect(status st:LoadStatus, message msg:String){
        
        switch st {
        case .Normal:
            print("Load Status: Normal")
            print(msg)
            mainmenu()
            //startgame()
        case .Warning:
            print("Load Status: Warning")
            print(msg)
            mainmenu()
        case .Critical:
            print("Load Status: Critical")
            print(msg)
        }
        
    }
    
    func mainmenu(){
        let scene = MainScene(size: self.view.bounds.size)
        scene.scaleMode = .aspectFill
        let skview = self.view as! SKView
        skview.isMultipleTouchEnabled = false
        skview.showsNodeCount = true
        skview.presentScene(scene)
    }
    
    func startgame(){
        let scene = StartGame(size: self.view.bounds.size)
        scene.scaleMode = .resizeFill
        let skview = self.view as! SKView
        skview.isMultipleTouchEnabled = false
        skview.showsNodeCount = true
        skview.presentScene(scene)
    }

    @IBAction func startgame(_ sender: Any) {
        
        let scene = StartGame(size: self.view.bounds.size)
        scene.scaleMode = .resizeFill
        let skview = self.view as! SKView
        skview.isMultipleTouchEnabled = false
        skview.showsNodeCount = true
        skview.presentScene(scene)
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

