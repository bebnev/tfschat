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
        let request = PhotosRequest(apiKey: "19158889-ff105cd65a08e15343a0c411c")
        return RequestConfig<PhotosParser>(request: request, parser: PhotosParser())
    }
    
    static func fetchImageConfig(urlString: String) -> RequestConfig<ImageParser> {
        let request = ImageRequest(urlString: urlString)
        return RequestConfig<ImageParser>(request: request, parser: ImageParser())
    }
    
}
