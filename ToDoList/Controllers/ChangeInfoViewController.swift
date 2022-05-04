//
//  ChangeInfoViewController.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 06.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import UIKit

class ChangeInfoViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    
    var name = String()
    var surname = String()
    var birthday = String()
    var image: UIImage?
    
    @IBOutlet weak var userImage: UserImage!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePicker()
        addTapImageViewRecognizer()
        setValues(image: image, name: name, surname: surname, birthday: birthday)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let birthday = birthdayTextField.text,
              name != "",
              surname != "",
              birthday != ""
        else { errorAlert(message: "Wrong input data"); return }
        
        if ageVerefy() {
            let userInfo = (name, surname, birthday)
            NetworkManager.changeUserInfo(userInfo: userInfo)
            navigationController?.popToRootViewController(animated: true)
        } else {
            errorAlert(message: "You need to be a 14 years old or higher")
            birthdayTextField.textColor = .red
        }
        
        guard let image = userImage.image else { return }
        NetworkManager.addUserPicture(image: image)
        
        
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
    
    private func errorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func setValues(image: UIImage?, name: String, surname: String, birthday: String) {
        
        nameTextField.text = name
        surnameTextField.text = surname
        birthdayTextField.text = birthday
        
        if image != nil {
            userImage.image = image
        } else {
            userImage.image = UIImage(named: "userDefault")
        }
        
    }
    
    private func addTapImageViewRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewGesture(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(recognizer)
    }
    
    @objc private func imageViewGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        showImageLibraryView()
    }

}

extension ChangeInfoViewController: UITextFieldDelegate {
    
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
       default:
            textField.resignFirstResponder()
       }
        
        return true
        
    }
    
}

extension ChangeInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    private func showImageLibraryView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        userImage.image = image
    }
    
    
}
