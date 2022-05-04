//
//  SignUpViewControllers.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 27.09.2020.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDatePicker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let birthday = birthdayTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let repeatedPassword = repeatedPasswordTextField.text,
              name != "",
              surname != "",
              birthday != "",
              email != "",
              password != "",
              repeatedPassword != ""
        else {
            return
        }
        
        if ageVerefy() {
            
            birthdayTextField.textColor = .black
            
            if password == repeatedPassword {
                
                passwordTextField.textColor = .black
                repeatedPasswordTextField.textColor = .black
                
                let user = User(name: name, surname: surname, birthday: birthday, email: email)
                
                NetworkManager.signUp(newUser: user, password: repeatedPassword) { [weak self] (user, error) in
                    guard error == nil else { self?.errorAlert(message: String(describing: error?.localizedDescription)); return }
                    guard user != nil else { self?.errorAlert(message: "User has not signed up. The user already has been created"); return }
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                
                
            } else {
                errorAlert(message: "Wrong password")
                passwordTextField.textColor = .red
                repeatedPasswordTextField.textColor = .red
            }
        } else {
            errorAlert(message: "You need to be a 14 years old to sign up!")
            birthdayTextField.textColor = .red
        }
        
    }
    
    private func errorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func addDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        guard let localeID = Locale.preferredLanguages.first else { return }
        datePicker.locale = Locale(identifier: localeID)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        birthdayTextField.inputAccessoryView = toolBar
        birthdayTextField.inputView = datePicker
        
    }

    @objc private func doneAction() {
        
        birthdayTextField.resignFirstResponder()
        emailTextField.becomeFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        
    }
    
    private func ageVerefy() -> Bool {
        
        let birthdtay = datePicker.date
        let calendar = Calendar.current
        let result = calendar.dateComponents([.year, .month, .day], from: birthdtay, to: Date())
        guard let age = result.year else { return false }
        
        return age >= 14
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    private func addKeyboardObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 5, right: 0)
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
       case nameTextField:
            textField.resignFirstResponder()
            surnameTextField.becomeFirstResponder()
       case surnameTextField:
            textField.resignFirstResponder()
            birthdayTextField.becomeFirstResponder()
       case birthdayTextField:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
       case emailTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
       case passwordTextField:
            textField.resignFirstResponder()
            repeatedPasswordTextField.becomeFirstResponder()
       case repeatedPasswordTextField:
            textField.resignFirstResponder()
       default:
            textField.resignFirstResponder()
       }
        
        return true
        
    }
    
}
