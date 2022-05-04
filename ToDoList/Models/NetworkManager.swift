//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 01.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class NetworkManager: NetworkManagerProtocol {    
        
    static func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            completion(user, error)
        }
        
    }
    
    static func signUp(newUser: User, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: newUser.email, password: password) { user, error in
            
            completion(user, error)
            
            let ref = Database.database().reference(withPath: "users").child(String((user?.user.uid)!))
            ref.setValue(["name": newUser.name,
                          "surname": newUser.surname,
                          "birthday": newUser.birthday,
                          "email": newUser.email])
            
        }
    }
    
    static func isLogedIn() -> Bool {
        return Auth.auth().currentUser != nil ? true : false
    }
    
    static func getUserId() -> String? {
        
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        return userId
        
    }
    
    static func getUser(completion: @escaping (_ user: User) -> ()) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference(withPath: "users").child(currentUser.uid)
        
        ref.observe(.value) { snapshot in
            
            let data = snapshot.value as! [String:AnyObject]
            var user = User(uid: currentUser.uid,
                            name: data["name"] as! String,
                            surname: data["surname"] as! String,
                            birthday: data["birthday"] as! String,
                            email: data["email"] as! String)
            user.imageUrl = currentUser.photoURL
            completion(user)
                
        }
        
    }
    
    static func addTask(task: Task) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference(withPath: "users").child(String(uid)).child("tasks").child(task.title.lowercased())
        
        ref.setValue(["title": task.title,
                      "userId": task.userId,
                      "completed": task.completed])
    
    }
    
    static func getTasks(completion: @escaping ([Task])->()) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
        
        ref.observe(.value) { (snapshot) in
            var tasks = [Task]()
            
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                tasks.append(task)
            }
            
            completion(tasks)
        }
    }
    
    static func addUserPicture(image: UIImage) {
        
        guard let userId = getUserId() else { return }
        let ref = Storage.storage().reference().child("avatars").child(userId)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metaData) { meta, error in
            guard let _ = meta else { return }
            ref.downloadURL { url, error in
                guard let url = url else { return }
                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                req?.photoURL = url
                req?.commitChanges(completion: nil)
            }
        }
        
    }
    
    static func getUserPicture(completion: @escaping (_ image: UIImage) -> () ) {
        
        guard let imageUrl = Auth.auth().currentUser?.photoURL else { return }
        print(imageUrl.absoluteString)
        let session = URLSession.shared
        session.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
        
    }
    
    static func changeUserInfo(userInfo: (name: String, surname: String, birthday: String)) {
        guard let userId = getUserId() else { return }
        let ref = Database.database().reference(withPath: "users").child(userId)

        ref.updateChildValues(["name": userInfo.name,
                               "surname": userInfo.surname,
                               "birthday": userInfo.birthday])
        
    }
    
    static func changeUserEmail(oldEmail:String, newEmail: String, password: String) {
        
        guard let userId = getUserId() else { return }
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
        let ref = Database.database().reference(withPath: "users").child(userId)
        let user = Auth.auth().currentUser
        
        user?.reauthenticate(with: credential, completion: { (auth, error) in
            auth?.user.updateEmail(to: newEmail, completion: nil)
            ref.updateChildValues(["email": newEmail])
        })
        
    }
    
    static func changeUserPassword(newPassword: String, oldPassword: String) {
        
        guard let email = Auth.auth().currentUser?.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        let user = Auth.auth().currentUser
        
        user?.reauthenticate(with: credential, completion: { auth, error in
            auth?.user.updatePassword(to: newPassword, completion: nil)
        })
        
    }
    
    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
        } catch {
            return false
        }
        return true
    }
    
}
