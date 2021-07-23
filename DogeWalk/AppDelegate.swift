//
//  AppDelegate.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 12.03.21.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let realm = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        checkIfFirstLaunch()
        checkUserDefaults()
        return true
    }

    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // skip tutorial
        } else {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "metricSelected")
            // show a little tutorial on how dogeWalk works
            UserDefaults.standard.synchronize()
        }
    }
    
    func checkUserDefaults() {
        if (UserDefaults.standard.string(forKey: "sortBy") != nil) {
            // there is already a Userdefault
        } else {
            // initial set of UserDefaults
            UserDefaults.standard.set("startDate", forKey: "sortBy")
        }
        
        if UserDefaults.standard.bool(forKey: "ascend") {
            //there is already a Userdefault
        } else {
            UserDefaults.standard.set(false, forKey: "ascend")
        }
        
        if (UserDefaults.standard.string(forKey: "dogFilter") != nil) {
            // there is already a Userdefault
        } else {
            let realm = try! Realm()
            let dogFilterResultObject = realm.objects(Dog.self)
            var dogFilter = [String]()
            
            for dog in dogFilterResultObject {
                dogFilter.append(dog.name)
            }
            let stringOfNames = dogFilter.joined(separator: ", ")
            
            UserDefaults.standard.set(stringOfNames , forKey: "dogFilter")
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

