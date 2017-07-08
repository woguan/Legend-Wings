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
        case Reset
        case Backup
    }
    
    enum State{
        case Backup
        case NoBackup
    }
    struct Plist {
        private var Root = [String]()
        private var Toon = [String]()
        private var ToonModel = [String]()
        
        func getRoot() -> [String]{
            return Root
        }
        func getToon() -> [String]{
            return Toon
        }
        func getModel() -> [String]{
            return ToonModel
        }
        mutating func addToRoot(str: String){
            Root.append(str)
        }
        mutating func addToToon(str: String){
            Toon.append(str)
        }
        mutating func addToModelToon(str: String){
            ToonModel.append(str)
        }
    }
    
    // Loading Scene Variables
    
    let rootview:UIImageView = {
        let view = UIImageView(image: UIImage(named: "initial_main_bg"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bview:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let loadLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 25)
        label.text = "Loading:"
        // label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelNumber:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 25)
        label.text = "0%"
        // labelNumber.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let imgView:UIView = {
        let img = UIImageView(image: UIImage(named: "initial_bg"))
        img.layer.cornerRadius = 20
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    // get user storage directory
    let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    private var defaultPlist = NSMutableDictionary()
    private var clientData = NSMutableDictionary()
   
    fileprivate var plistcheck = Plist()
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Notification
        let preloadNotification = Notification.Name(rawValue:"PreloadNotification")
        let progressNotification = Notification.Name(rawValue:"ProgressNotification")
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:preloadNotification, object:nil, queue:nil, using:preloadDone)
        nc.addObserver(forName: progressNotification, object: nil, queue: nil, using:progressTrack)
        
        loadingScene() // Progress Scene
        
        load()
    }
    
    func load(){
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
        
        defaultPlist = originalPlist
        
        // load the contents into a variable
        guard let virtualPList = NSMutableDictionary(contentsOfFile: fullPathName) else{
            
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: fullPathName){
                // savingx
                if !originalPlist.write(toFile: fullPathName, atomically: false){
                    redirect(status: .Critical, message: "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController")
                }
            }
            clientData = originalPlist
            redirect(status: .Warning, message: "[Notice]: OriginalPlist being used.")
            return
        }
        
        clientData = virtualPList
        
        // Bulding up PlistChecker Variable
        buildPlistChecker()
        // Client has plist. Checking if client needs to update plist.
        let (isGoodData, isBackupPossible, msg) = isChecked()
        
        if isGoodData{
            redirect(status: .Normal, message: "Success")
        }
        else if isBackupPossible{
            print(msg)
            redirect(status: .Backup, message: "Updating client's Plist and Performing Restore")
        }
        else{
            print(msg)
            redirect(status: .Reset, message: "Reseting client's Plist")
        }
    }
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func buildPlistChecker(){
        for key in defaultPlist.allKeys{
            // root
            plistcheck.addToRoot(str: key as! String)
        }
        
        let toonDict = defaultPlist.value(forKey: "Toons") as! NSDictionary
        
        for key in toonDict.allKeys{
            // Toons
            plistcheck.addToToon(str: key as! String)
        }
        
        for key in (toonDict.value(forKey: "ModelToons") as! NSDictionary).allKeys{
            // ModelKeys
            plistcheck.addToModelToon(str: key as! String)
        }
        
    }
    
    // .0 : Is Good Data
    // .1 : Is backup Possible
    // .2 : Alert Message
    private func isChecked() -> (Bool, Bool, String){
        
        let isBackupPossible:Bool = true
        
        // First Check: Check if Backup will be possible
        
        // Check if all keys in client-side can be fitted in Default Plist
        for root in clientData.allKeys{
            if !self.plistcheck.getRoot().contains(root as! String){
                return(false, false, "Report: Client Plist Root Item: (\(root as! String)) - Not included in OriginalPlist")
            }
            if root as! String == "Toons"{
                // Toons exist in the root
                // Need to check if it is a dictionary
                if let toonsDict = clientData.value(forKey: root as! String) as? NSDictionary{
                      for toon in toonsDict.allKeys{
                         // Check if all keys of Toons can be matched to the new database
                        if (!plistcheck.getToon().contains(toon as! String)){
                            return (false, false, "Report: Client Plist Toons Item: (\(toon as! String)) - Not included in OriginalPlist")
                        }
                        // Checking if model toons is a dictionary
                        if let modelToonsDict = toonsDict.value(forKey: toon as! String) as? NSDictionary{
                            for modeltoon in modelToonsDict.allKeys{
                                if !plistcheck.getModel().contains(modeltoon as! String){
                                    return (false, false, "Report: Client Plist ModelToon Item: (\(modeltoon as! String)) - Not included in OriginalPlist")
                                }
                            }
                        }
                        else{
                            // modelToon is not a dictionary
                            return (false, false, "Report: Client Plist one or more ModelToon is not a dictionary. One or more Toons' key is not a dictionary")
                        }
                        
                        
                     }
                }
                else{
                    return (false, false, "Report: Client Plist Toons is not a dictionary")
                }
              
            }
            
        }
        
        // Check for Root Sizes
        if clientData.count != defaultPlist.count{
            return (false, isBackupPossible, "Client's Root is missing one or more key. Updating client plist")
        }
        
        // Check for Toons sizes
        let clientToons = clientData.value(forKey: "Toons") as! NSDictionary
        let defaultToons = defaultPlist.value(forKey: "Toons") as! NSDictionary
        if clientToons.count != (defaultToons).count{
            return (false, isBackupPossible, "Client's Toons is missing one or more key. Updating client plist")
        }
        
        // Check for Model Toons
        for mkey in clientToons.allKeys{
            if (clientToons.value(forKey: mkey as! String) as! NSDictionary).count != (defaultToons.value(forKey: mkey as! String) as! NSDictionary).count{
                return (false, isBackupPossible, "Client's model toons named: (\(mkey as! String)) has fewer keys than OriginalPlist. Updating client plist")
            }
        }
        
        
        // Passed all checkers. Client Plist can be loaded without errors.
        return (true, isBackupPossible, "Successfully Checked with no errors")
    }
    
    private func redirect(status st:LoadStatus, message msg:String){
        
        switch st {
        case .Normal:
            print("Load Status: Normal")
            print(msg)
            mainmenu()
        case .Warning:
            print("Load Status: Warning")
            print(msg)
            mainmenu()
        case .Critical:
            print("Load Status: Critical")
            print(msg)
        case .Backup:
            print("Load Status: Backup")
            print(msg)
            backup(filepath: documentDir.appendingPathComponent("userinfo.plist"))
            mainmenu()
        case .Reset:
            print("Load Status: Reset") //Virtual List exists, but needs update
            hardReset(filepath: documentDir.appendingPathComponent("userinfo.plist"))
            mainmenu()
        }
        
    }
    
   private func mainmenu(){
       // print ("Client Plist Data: ", clientData)
        global.prioirityLoad()
    }
    
   private func preloadDone(notification:Notification){
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let scene = MainScene(size: self.view.bounds.size)
            scene.scaleMode = .aspectFill
            let skview = self.view as! SKView
            skview.isMultipleTouchEnabled = false
            skview.showsNodeCount = true
            skview.presentScene(scene)
        }
    }
    private func hardReset(filepath: String){
        if !defaultPlist.write(toFile: filepath, atomically: false){
            redirect(status: .Critical, message: "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController.hardReset")
        }
        clientData = defaultPlist
    }
    
    private func backup(filepath: String){
        
        let newPlist = defaultPlist
        // Copying Root
        for key in clientData.allKeys{
            if ( key as! String == "Toons"){
                continue // Avoid copying Dictionaries
            }
            newPlist.setValue(clientData.value(forKey: key as! String), forKey: key as! String)
        }
        // Copying Toons
        for key in (clientData.value(forKey: "Toons") as! NSDictionary).allKeys{
            if (key as! String == "ModelToons"){
                continue // skip the model
            }
            newPlist.setValue(clientData.value(forKey: key as! String), forKey: key as! String)
        }
        
        if !newPlist.write(toFile: filepath, atomically: false){
            redirect(status: .Critical, message: "FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN ViewController.backup")
        }
     
        clientData = newPlist
    }
    
    private func loadingScene(){
        // x, y, width, height
        
        view.addSubview(rootview)
        view.addSubview(bview)
        bview.addSubview(imgView)
        bview.addSubview(loadLabel)
        loadLabel.addSubview(labelNumber)
        
        rootview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rootview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rootview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rootview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        bview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        bview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        bview.heightAnchor.constraint(equalToConstant: screenSize.height/2).isActive = true
        
        imgView.centerXAnchor.constraint(equalTo: bview.centerXAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: bview.topAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: bview.widthAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: screenSize.height/3.5).isActive = true
        
        loadLabel.centerXAnchor.constraint(equalTo: bview.centerXAnchor, constant: -50).isActive = true
        loadLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 50).isActive = true
        loadLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        labelNumber.leftAnchor.constraint(equalTo: loadLabel.rightAnchor).isActive = true
        labelNumber.centerYAnchor.constraint(equalTo: loadLabel.centerYAnchor).isActive = true
        labelNumber.widthAnchor.constraint(equalToConstant: screenSize.width/4).isActive = true
        labelNumber.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    private func progressTrack(notification:Notification){
        let percentage = notification.userInfo?["Left"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.labelNumber.text =  String(percentage as! Int) + "%"
        }
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

