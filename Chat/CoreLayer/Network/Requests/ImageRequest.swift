//
//  ImageRequest.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    var urlString: String
    var urlRequest: URLRequest? {
        if let url = URL(string: self.urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    init(urlString: String) {
        self.urlString = urlString
    }
}
