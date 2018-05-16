//
//  MealDetailViewController.swift
//  FoodOrder
//
//  Created by Zindo Yamate on 5/12/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {

    var meal: Meal?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var descriptions: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        descriptions.delegate = self
        descriptions.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        configureMeal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        descriptions.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedImage(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        descriptions.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mealMasterVC = segue.destination as? MealMasterViewController {
            let context = mealMasterVC.fetchResultsController.managedObjectContext
            if mealMasterVC.tableView.indexPathForSelectedRow == nil {
                meal = Meal(context: context)
            }
            meal?.name = nameTextField.text
            meal?.photo = imageView.image
            meal?.rating = Int32(ratingControl.rating)
            meal?.descriptions = descriptions.text
            DataServices.shared.saveContext()
        }
    }
    
    func configureMeal() {
        if let selectedMeal = meal {
            nameTextField.text = selectedMeal.name
            imageView.image = selectedMeal.photo as? UIImage
            ratingControl.rating = Int(selectedMeal.rating)
            descriptions.text = selectedMeal.descriptions
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
