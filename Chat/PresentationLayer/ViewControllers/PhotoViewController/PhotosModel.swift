//
//  PhotosModel.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IPhotosModelDelegate: class {
    func setup(dataSource: Photos)
    func show(error message: String)
}

protocol IPhotosModel {
    var delegate: IPhotosModelDelegate? { get set }
    func fetchPhotos()
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void)
}

class PhotosModel: IPhotosModel {
    
    weak var delegate: IPhotosModelDelegate?
    let photosService: IPhotosService
    
    init(photosService: IPhotosService) {
        self.photosService = photosService
    }
    
    func fetchPhotos() {
        photosService.fetchPhotos { [weak self] (photos, error) in
            print(Thread.isMainThread)
            if let photos = photos {
                self?.delegate?.setup(dataSource: photos)
            } else {
                self?.delegate?.show(error: error ?? "Error")
            }
        }
    }
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        photosService.fetchImage(urlString: urlString) { (imageModel: ImageModel?, error: String?) in
            if let imageModel = imageModel {
                completionHandler(imageModel.image, error)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
}
