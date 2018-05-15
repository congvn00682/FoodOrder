//
//  User.swift
//  FoodOrder
//
//  Created by Vu Ngoc Cong on 5/15/18.
//  Copyright © 2018 Zindo Yamate. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
        struct Key {
        static let name = "Name"
        static let image = "Image"
        static let email = "Email"
    }
    
    var name: String
    var image: String
    var email: String
    
    init(name: String, image: String, email: String) {
        self.name = name
        self.image = image
        self.email = email
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name)
        aCoder.encode(image, forKey: Key.image)
        aCoder.encode(email, forKey: Key.email)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Key.name) as? String else { return nil }
        guard let image = aDecoder.decodeObject(forKey: Key.image) as? String else { return nil }
        guard let email = aDecoder.decodeObject(forKey: Key.email) as? String else { return nil }
        self.init(name: name, image: image, email: email)
    }
    
}
