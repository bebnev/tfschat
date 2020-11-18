//
//  ProfileViewController+Camera.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import AVFoundation

extension ProfileViewController {
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    func requestCameraPermissions() {
        if !isCameraAvailable() {
            return
        }
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraAuthStatus {
        case .authorized:
            hasCameraPermissions = true
        case .denied, .restricted:
            hasCameraPermissions = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (authorized) in
                self.hasCameraPermissions = authorized
            }
        @unknown default:
            hasCameraPermissions = false
        }
    }
}
