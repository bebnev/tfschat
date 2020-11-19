//
//  PhotosRequest.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class PhotosRequest: IRequest {
    //private var baseUrl: String = "https://pixabay.com/api/?key=19158889-ff105cd65a08e15343a0c411c&q=yellow+flowers&image_type=photo&pretty=true&per_page=10"
    private var baseUrl = "https://pixabay.com/"
    private let apiVersion = "api/"
    private let search = "yellow+flowers"
    private let perPage = "100"
    private let imageType = "photo"
    private let pretty = "true"
    private let apiKey: String
    
    var urlRequest: URLRequest? {
        let key = "key=\(self.apiKey)&"
        let searchParams = "q=\(self.search)&"
        let type = "image_type=\(self.imageType)&"
        let enablePreety = "pretty=\(self.pretty)&"
        let page = "per_page=\(self.perPage)"
        let urlString = self.baseUrl + self.apiVersion + "?" + key + searchParams + type + enablePreety + page
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
