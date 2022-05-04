//
//  UserViewController.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 01.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var userImage: UserImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {

        if NetworkManager.signOut() {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func getUserData() {
        NetworkManager.getUser() { user in
            
            self.nameLabel.text = user.name
            self.surnameLabel.text = user.surname
            self.birthdayLabel.text = user.birthday
            self.mailLabel.text = user.email
            if user.imageUrl == nil {
                self.userImage.image = UIImage(named: "userDefault")
            } else {
                NetworkManager.getUserPicture { image in
                    self.userImage.image = image
                }

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
       
        if destination is ChangeInfoViewController {
            guard let vc = destination as? ChangeInfoViewController,
                  let user = getData() else { return }
            vc.name = user.name
            vc.surname = user.surname
            vc.birthday = user.birthday
            
        }
        
    }
    
    private func getData() -> User? {
        guard let name = nameLabel.text,
              let surname = surnameLabel.text,
              let birthday = birthdayLabel.text,
              let email = mailLabel.text
        else { return nil }
        
        return User(name: name, surname: surname, birthday: birthday, email: email)
        
    }
    

}
