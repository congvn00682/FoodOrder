//
//  MasterViewController.swift
//  FoodOrder
//
//  Created by Zindo Yamate on 5/12/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit
import CoreData

class MealMasterViewController: UITableViewController, UISearchBarDelegate {

    
    var filtered: [Meal] = []
    var fetchResultsController = DataServices.shared.fetchedResultsController
    @IBOutlet weak var searchMeal: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController.delegate = self
        searchMeal.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMeal.text != "" {
            return filtered.count
        }
        guard let meals = fetchResultsController.fetchedObjects else { return 0 }
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MealTableViewCell
        
        if searchMeal.text != "" {
            let meal = filtered[indexPath.row]
            cell.nameLabel.text = meal.name
            cell.photo.image = meal.photo as? UIImage
            cell.ratingControl.rating = Int(meal.rating)
        }
        else {
            let meal = fetchResultsController.object(at: indexPath)
            configureCell(cell, withMeal: meal)
        }
        return cell
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let objects = fetchResultsController.object(at: indexPath)
            let mealDetailController = segue.destination as? MealDetailViewController
            mealDetailController?.meal = objects
        }
    }
    
    func configureCell(_ cell: MealTableViewCell, withMeal event: Meal) {
        cell.photo.image = event.photo as? UIImage
        cell.nameLabel.text = event.name
        cell.ratingControl.rating = Int(event.rating)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let context = fetchResultsController.managedObjectContext
            context.delete(fetchResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let fetchedObjects = fetchResultsController.fetchedObjects else { return }
        filtered = fetchedObjects.filter({ (filtered) -> Bool in
            let foldingNameMealEntity = filtered.name?.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current)
            let foldingSearchText = searchText.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current)
            return (foldingNameMealEntity ?? "").contains(foldingSearchText)
        })
        tableView.reloadData()
    }

}
extension MealMasterViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!) as! MealTableViewCell, withMeal: anObject as! Meal)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!) as! MealTableViewCell, withMeal: anObject as! Meal)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension String {
    var toInt: Int? {
        get {
            return self != "" ? Int(self) : nil
        }
    }
}

