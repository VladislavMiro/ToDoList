//
//  User.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 01.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import Foundation
import Firebase

struct User: UserProtocol {
    
    var uid: String?
    var name: String
    var surname: String
    var birthday: String
    var email: String
    var imageUrl: URL?
    
    init(name: String, surname: String, birthday: String, email: String) {
        self.name = name
        self.surname = surname
        self.birthday = birthday
        self.email = email
        uid = nil
        imageUrl = nil
    }
       
    init(uid: String, name: String, surname: String, birthday: String, email: String) {
        self.init(name: name, surname: surname, birthday: birthday, email: email)
        self.uid = uid
    }
    
}
