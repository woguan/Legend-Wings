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

    override func viewDidLoad() {
        super.viewDidLoad()
        // get user storage directory
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        // append it with the plist we created
        let fullPathName = documentDir.appendingPathComponent("userinfo.plist")
        guard let sourceFilePath = Bundle.main.path(forResource: "userinfo", ofType: "plist") else{
            print ("Error001:: userinfo.plist does not exist at all. Please, add plist file to the main path")
            return
        }
        
        guard let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath) else{
            print ("Error002: Error loading contents of  \(fullPathName)")
            return
        }
        
        // load the contents into a variable
        guard let virtualPList = NSMutableDictionary(contentsOfFile: fullPathName) else{
            
            print ("[Notice]: OriginalPlist being used.")
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: fullPathName){
                // savingx
                if !originalPlist.write(toFile: fullPathName, atomically: false){
                    print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController")
                }
            }
            return
        }
        
        // this variable will check if the plist is already in user's storage path
        print ("VirtualPlist exists: ", virtualPList)
        
        
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
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

