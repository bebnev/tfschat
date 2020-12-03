//
//  ConversationVoewController+UITextFieldDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendTap()
        return true
    }
}
