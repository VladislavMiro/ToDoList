//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 27.09.2020.
//

import Foundation
import FirebaseCore
import FirebaseAuth

protocol NetworkManagerProtocol {
  
    static func signIn(email: String, password: String, completion: @escaping (_ authDataResult: AuthDataResult?, _ error: Error? ) -> ())
    
    static func signUp(newUser: User, password: String, completion: @escaping (_ authDataResult: AuthDataResult?, _ error: Error?)->())
    
    static func getUser(completion: @escaping (_ user: User) -> ())
    
    static func getUserId() -> String?
    
    static func isLogedIn() -> Bool
    
    static func addTask(task: Task)
    
    static func getTasks(completion: @escaping ([Task])->())
    
    static func addUserPicture(image: UIImage)
    
    static func getUserPicture(completion: @escaping (_ image: UIImage) -> ())
    
    static func changeUserInfo(userInfo: (name: String, surname: String, birthday: String))
    
    static func changeUserEmail(oldEmail: String, newEmail: String, password: String)
    
    static func changeUserPassword(newPassword: String, oldPassword: String) 
    
    static func signOut() -> Bool
    
}
