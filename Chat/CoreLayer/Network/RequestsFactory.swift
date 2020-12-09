//
//  RequestsFactory.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

struct RequestsFactory {
    static func photosConfig() -> RequestConfig<PhotosParser> {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PIXABAY_API_TOKEN") as? String, apiKey != "" else {
            fatalError("Can not get pixabay api token")
        }
        
        let request = PhotosRequest(apiKey: apiKey)
        return RequestConfig<PhotosParser>(request: request, parser: PhotosParser())
    }
    
    static func fetchImageConfig(urlString: String) -> RequestConfig<ImageParser> {
        let request = ImageRequest(urlString: urlString)
        return RequestConfig<ImageParser>(request: request, parser: ImageParser())
    }
    
}
