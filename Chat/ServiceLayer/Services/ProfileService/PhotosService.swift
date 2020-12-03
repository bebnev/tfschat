//
//  PhotosService.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IPhotosService {
    func fetchPhotos(completionHandler: @escaping (Photos?, String?) -> Void)
    func fetchImage(urlString: String, completion: @escaping (ImageModel?, String?) -> Void)
}

class PhotosService: IPhotosService {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func fetchPhotos(completionHandler: @escaping (Photos?, String?) -> Void) {
        let requestConfig = RequestsFactory.photosConfig()
        requestSender.send(requestConfig: requestConfig) { (result) in
            switch result {
            case .success(let photos):
                completionHandler(photos, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (ImageModel?, String?) -> Void) {
        let requestConfig = RequestsFactory.fetchImageConfig(urlString: urlString)
        requestSender.send(requestConfig: requestConfig) { (result) in
            switch result {
            case .success(let image):
                completion(image, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
