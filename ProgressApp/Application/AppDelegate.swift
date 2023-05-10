//
//  AppDelegate.swift
//  ProgressApp
//
//  Created by Aliaksandr on 5.09.22.
//

import UIKit
import CoreData
import FirebaseCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        DataBaseManager.shared.setupDataBase()
        AsyncManager.shared.setupSelectedAsyncOperation()
        
        if let dataBaseRawValue = UserDefaults.standard.string(forKey: "DataBaseType") {
            DataBaseManager.shared.setSelectedDataBase(selectedDataBase: DataBase(rawValue: dataBaseRawValue) ?? .coreData)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        TabBarCoordinator(window: window).start()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}
