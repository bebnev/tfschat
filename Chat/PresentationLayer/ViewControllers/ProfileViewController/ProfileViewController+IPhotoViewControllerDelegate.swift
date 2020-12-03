//
//  ProfileViewController+IPhotoViewControllerDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ProfileViewController: IPhotoViewControllerDelegate {
    func photoPickerController(_ picker: PhotoViewController, didFinishPickingImage image: UIImage) {
        guard let profile = presentationAssembly?.profileManager.profile else { return }
        isAvatarChanged = image != profile.avatar
        DispatchQueue.main.async { [weak self] in
            self?.drawAvatar(with: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
