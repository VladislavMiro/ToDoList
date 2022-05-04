//
//  Task.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 03.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import Foundation
import Firebase

struct Task: TaskProtocol {
    var title: String
    var userId: String
    var ref: DatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
}
