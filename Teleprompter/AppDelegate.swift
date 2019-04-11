//
//  AppDelegate.swift
//  Teleprompter
//
//  Created by Josiah Agosto on 3/19/19.
//  Copyright © 2019 Josiah Agosto. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if let rootVC = window?.rootViewController as? HomeViewController {
//            // Name Container i put in the HomeViewController
//            rootVC.container = persistentContainer
//        }
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Saves the data when the App is closed down.
        self.saveContext()
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "audioDataModel")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

