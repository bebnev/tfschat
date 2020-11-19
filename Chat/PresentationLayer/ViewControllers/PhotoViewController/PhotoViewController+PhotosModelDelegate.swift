//
//  PhotoViewController+PhotosModelDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

extension PhotoViewController: IPhotosModelDelegate {
    func setup(dataSource: Photos) {
        self.dataSource = dataSource
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.collectionView.reloadData()
        }
    }
    
    func show(error message: String) {
        DispatchQueue.main.async { [weak self] in
            if let controller = self?.presentationAssembly?.alertManager.error(message: message) {
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}
