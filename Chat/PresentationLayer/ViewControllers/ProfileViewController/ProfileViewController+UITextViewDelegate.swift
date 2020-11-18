//
//  ProfileViewController+UITextViewDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let profile = presentationAssembly?.profileManager.profile else {
            return
        }
        
        switch textView.tag {
        case 0:
            isNameChanged = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != profile.name
        case 1:
            isAboutChanged = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) != profile.about
        default:
            return
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 && text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
