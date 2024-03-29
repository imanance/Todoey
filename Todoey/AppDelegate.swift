//
//  AppDelegate.swift
//  Todoey
//
//  Created by Iman on 2024-02-19.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("application Lifecycle: #1 \(#function)")
        
        // ../Library/Preferences -> is UserDefaults pList file
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
//        
//        if #available(iOS 15, *) {
//            // MARK: Navigation bar appearance
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            navigationBarAppearance.titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor : UIColor.white
//            ]
//            
//            navigationBarAppearance.backgroundColor = .systemBlue
//            navigationBarAppearance.shadowColor = .clear
//            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//            
//            // MARK: Tab bar appearance
//            let tabBarAppearance = UITabBarAppearance()
//            tabBarAppearance.configureWithOpaqueBackground()
//            tabBarAppearance.backgroundColor = .systemBlue
//            
//            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//            UITabBar.appearance().standardAppearance = tabBarAppearance
//        }
        
        
        // ## Realm
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new Realm, \(error)")
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("application Lifecycle: \(#function)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // use this method to release shared resources, save your data, invalidate timers, and store enough aplication state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("application Lifecycle: \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Save changes in the application's managed object context before the application terminates.
        print("application Lifecycle: \(#function)")
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

