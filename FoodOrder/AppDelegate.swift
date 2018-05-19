//
//  AppDelegate.swift
//  FoodOrder
//
//  Created by Zindo Yamate on 5/12/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import KRProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // ktra thong tin login fb
        KRProgressHUD.show(withMessage: "Loading...")
        if let data = UserDefaults.standard.data(forKey: "user"),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            print(user.name, user.email)
            let confirmStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let showConfirmVC = confirmStoryboard.instantiateViewController(withIdentifier: "SlideMenuViewController") as! SlideMenuViewController
            let navigationController = UINavigationController(rootViewController: showConfirmVC)
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            KRProgressHUD.dismiss()
        } else {
            print("There is an issue")
            KRProgressHUD.dismiss()
        }
//        if (UserDefaults.standard.string(forKey: "email") != nil) {
//            let confirmStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let showConfirmVC = confirmStoryboard.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController
//            let navigationController = UINavigationController(rootViewController: showConfirmVC)
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.rootViewController = navigationController
//            window?.makeKeyAndVisible()
////            KRProgressHUD.dismiss()
//        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        AppDelegate.saveContext()
    }

    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FoodOrder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support

    static func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
                print("Save Success")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

