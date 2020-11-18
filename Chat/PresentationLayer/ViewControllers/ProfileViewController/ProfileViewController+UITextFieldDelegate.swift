//
//  ProfileViewController+UITextFieldDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        
        return false
    }
}
