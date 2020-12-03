//
//  PhotoCollectionViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
