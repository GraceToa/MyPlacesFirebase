//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Grace Toa on 26/9/18.
//  Copyright © 2018 Grace Toa. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         FirebaseApp.configure()
        
   
        UINavigationBar.appearance().barStyle = .blackOpaque
    
        //check json file exist in local system
        let pathFileJson = ManagerPlaces.shared.findDocumentDir(file: ManagerPlaces.NAME_JSON_FILE)
        let fileManager = FileManager.default
        var directory: ObjCBool = ObjCBool(false)
        
        if !fileManager.fileExists(atPath: (pathFileJson.path), isDirectory: &directory) {
            fileManager.createFile(atPath: pathFileJson.path, contents: nil, attributes: nil)
            ManagerPlaces.shared.dadesLoadJSONFirsTime()
        } else {
            print("JSON File Already exists")
            ManagerPlaces.shared.dadesLoadJSON()
        }
        return true
    }

  
}

