//
//  DataServices.swift
//  FoodOrder
//
//  Created by Zindo Yamate on 5/12/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreData

class DataServices {
    
    static let shared: DataServices = DataServices()
    
    func getDataLogin() {
        if FBSDKAccessToken.current() != nil {
            // lay gia tri (id: co the hien thi anh, name, email) cua fb sau khi login thanh cong
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {
                (connect, result, err) in
                if err == nil {
                    // luu cac gia tri vao 1 Dictionary
                    let dict = result as! Dictionary<String, Any>
                    print("Info \(dict)")
                    // lay cac gia tri de co the luu thong tin or hien thi
                    //                    let linkId: String = dict["id"] as! String
                    let name: String = dict["name"] as! String
                    let email: String = dict["email"] as! String
                    let linkPicture = dict["picture"] as! [String : AnyObject]
                    let data = linkPicture["data"] as! [String : AnyObject]
                    let image = data["url"] as! String
                    
//                    UserDefaults.standard.set(linkEmail, forKey: "email")
                    let user = User(name: name, image: image, email: email)
                    
                    // ep gia tri vao 1 object
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
                    // luu Object vao userDefaults
                    UserDefaults.standard.set(encodedData, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    
//                    // set rootView. move to new screen
//                    let application = UIApplication.shared.delegate as! AppDelegate
//                    let confirmStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let showConfirmVC = confirmStoryboard.instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController
//                    let navigationController = UINavigationController(rootViewController: showConfirmVC)
//                    application.window?.rootViewController = navigationController
                    
                    
                }
            })
        }
    }
    
    func getUserInfo(complete: (User)-> Void) {
        let decoded = UserDefaults.standard.object(forKey: "user") as! Data
        guard let user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User else { return }
        complete(user)
    }
    
    var fetchedResultsController: NSFetchedResultsController<Meal> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let nameMeal = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [nameMeal]
        
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    private var _fetchedResultsController: NSFetchedResultsController<Meal>?
    
    func saveContext() {
        guard let context = _fetchedResultsController?.managedObjectContext else { return }
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
