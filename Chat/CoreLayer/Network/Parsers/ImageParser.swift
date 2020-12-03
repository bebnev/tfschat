//
//  ImageParser.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

struct ImageModel {
    let image: UIImage
}
class ImageParser: IParser {
    typealias Model = ImageModel
    func parse(data: Data) -> ImageParser.Model? {
        if let image = UIImage(data: data) {
            return ImageModel(image: image)
        }
        return nil
    }
}
