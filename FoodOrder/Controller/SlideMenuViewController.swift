//
//  SlideMenuViewController.swift
//  FoodOrder
//
//  Created by Vu Ngoc Cong on 5/17/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    
    @IBOutlet weak var tableViewMainMenu: UIView!
    @IBOutlet weak var selectedMenu: UIButton!
    @IBOutlet weak var slideMenuContainer: UIView!
    @IBOutlet weak var leftConstraintSlideMenu: NSLayoutConstraint!
    
    var isOpenSlideMenu: Bool = false {
        didSet {
            leftConstraintSlideMenu.constant = isOpenSlideMenu ? 0 : -(UIScreen.main.bounds.width * 0.8 + 20)
            selectedMenu.isHidden = !isOpenSlideMenu
            UIView.animate(withDuration: 0.35){
                self.view.layoutIfNeeded()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        leftConstraintSlideMenu.constant = -(UIScreen.main.bounds.width * 0.8 + 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickCoverButton(_ sender: UIButton) {
        isOpenSlideMenu = !isOpenSlideMenu
    }
    
    @IBAction func onClickMenuButton(_ sender: Any) {
        isOpenSlideMenu = !isOpenSlideMenu
    }
}
