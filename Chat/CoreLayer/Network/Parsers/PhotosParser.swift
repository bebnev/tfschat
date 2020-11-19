//
//  PhotosParser.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    let items: [Photo]
    
    struct Photo: Decodable {
        let id: Int
        let previewURL: String
        let largeImageURL: String
        let webformatURL: String
    }
    
    enum CodingKeys: String, CodingKey {
        case items = "hits"
    }
}

class PhotosParser: IParser {
    typealias Model = Photos
    
    func parse(data: Data) -> Photos? {
        do {
            let dataModel = try JSONDecoder().decode(Photos.self, from: data)
            return dataModel
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
