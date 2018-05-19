//
//  InfoUserViewController.swift
//  FoodOrder
//
//  Created by Vu Ngoc Cong on 5/18/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit

class InfoUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listDishImage: UIButton!
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDishImage.layer.cornerRadius = 10
        takePhoto.layer.cornerRadius = 10
        logOut.layer.cornerRadius = 10
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        //get data from object
        DataServices.shared.getUsersInfo{[unowned self] user in
            self.imageView.download(from: user.image)
            self.nameLabel.text = user.name
            self.emailLabel.text = user.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedPhoto(_ sender: UITapGestureRecognizer) {
    }
    
    
    
    @IBAction func logOutAccount(_ sender: Any) {
    }
    
}
