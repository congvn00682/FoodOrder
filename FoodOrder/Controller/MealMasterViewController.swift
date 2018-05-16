//
//  MasterViewController.swift
//  FoodOrder
//
//  Created by Zindo Yamate on 5/12/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit
import CoreData

class MealMasterViewController: UITableViewController {

    var fetchResultsController = DataServices.shared.fetchedResultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MealTableViewCell
        let meal = fetchResultsController.object(at: indexPath)
        configureCell(cell, withMeal: meal)
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

