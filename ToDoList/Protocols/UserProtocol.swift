//
//  User.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 27.09.2020.
//

import Foundation

protocol UserProtocol {
    var uid: String? { get set }
    var name: String { get set }
    var surname: String { get set }
    var birthday: String { get set }
    var email: String { get set }
    var imageUrl: URL? { get set }
    
    init(name: String, surname: String, birthday: String, email: String)
    
    init(uid: String, name: String, surname: String, birthday: String, email: String)
    
}
