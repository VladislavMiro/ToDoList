//
//  LogInViewController.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 27.09.2020.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        addKeyboardObserver()
        loginCheck()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != "" else { errorAlert(message: "Wrong password or email"); return }
        NetworkManager.signIn(email: email, password: password) { [weak self] user, error in
            guard (error == nil) else { self?.errorAlert(message: String(describing: error)); return }
            guard (user != nil) else { self?.errorAlert(message: "User has not found!"); return }
                       
            self?.performSegue(withIdentifier: "mainView", sender: nil)
        }
        
    }
    
    private func errorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true)
        
    }
    
    private func loginCheck() {
        
        if NetworkManager.isLogedIn() {
            
            performSegue(withIdentifier: "mainView", sender: nil)
        }
        
    }

}
//: Work with keyboard
extension LogInViewController: UITextFieldDelegate {
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        print("\(keyboardSize.height)")
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
