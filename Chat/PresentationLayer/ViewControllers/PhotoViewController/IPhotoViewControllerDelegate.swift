//
//  IPhotosViewControllerDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IPhotoViewControllerDelegate: class {
    func photoPickerController(_ picker: PhotoViewController, didFinishPickingImage image: UIImage)
}
