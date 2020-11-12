//
//  ProfileViewController+UIImagePickerControllerDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage, let profile = presentationAssembly?.profileManager.profile else { return }
        isAvatarChanged = image != profile.avatar
        DispatchQueue.main.async { [weak self] in
            self?.drawAvatar(with: image)
        }
        dismiss(animated: true)
    }
}
