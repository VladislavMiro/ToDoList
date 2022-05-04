//
//  ChangePasswordViewController.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 06.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatedNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let oldPassword = oldPasswordTextField.text,
              let newPassword = newPasswordTextField.text,
              let repeatedNewPassword = repeatedNewPassword.text
        else { return }
        
        if newPassword == repeatedNewPassword {
            NetworkManager.changeUserPassword(newPassword: newPassword, oldPassword: oldPassword)
        } else {
            
        }
        
    }
    
    

}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       switch textField {
       case oldPasswordTextField:
            textField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
       case newPasswordTextField:
            textField.resignFirstResponder()
       default:
            textField.resignFirstResponder()
       }
        
        return true
        
    }
}
