//
//  ChangeEmailViewController.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 06.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var oldEmailTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let newEmail = newEmailTextField.text,
              let oldEmail = oldEmailTextField.text,
              let password = passwordTextField.text,
              newEmail != "",
              oldEmail != "",
              password != ""
        else { errorAlert(message: "Wrong input data"); return }
        
        NetworkManager.changeUserEmail(oldEmail: oldEmail, newEmail: newEmail, password: password)
        
    }
 
    private func errorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ChangeEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newEmailTextField.resignFirstResponder()
        return true
    }
}
