//
//  TaskProtocol.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 03.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import Foundation
import Firebase

protocol TaskProtocol {
    var title: String { get }
    var userId: String { get }
    var ref: DatabaseReference? { get set }
    var completed: Bool { get set }
    
    init(title: String, userId: String)
    
    init(snapshot: DataSnapshot)
    
}
