//
//  UserImage.swift
//  ToDoList
//
//  Created by Vladislav Miroshnichenko on 04.10.2020.
//  Copyright © 2020 Vladislav Miroshnichenko. All rights reserved.
//

import UIKit

@IBDesignable
class UserImage: UIImageView {

    @IBInspectable private var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable private var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        
    }

}
