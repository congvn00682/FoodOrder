//
//  Extension+UIImageView.swift
//  FoodOrder
//
//  Created by Vu Ngoc Cong on 5/18/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import UIKit

extension UIImageView {
    func download(from urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
