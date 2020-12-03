//
//  PhotoViewController+CollectionView.swift
//  Chat
//
//  Created by Anton Bebnev on 19.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self),
                                           for: indexPath) as? PhotoCollectionViewCell,
            let photoModel = dataSource?.items[indexPath.item] else {
                return UICollectionViewCell()
        }
        cell.configure(image: UIImage(named: "placeholder")!)
        
        if let cashedimage = imageCache.object(forKey: photoModel.largeImageURL as NSString),
            let existImage = cashedimage as? UIImage {
            cell.configure(image: existImage)
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.model?.fetchImage(urlString: photoModel.webformatURL) { [weak self] (image, _) in
                    if let image = image {
                        DispatchQueue.main.async {
//                            if self?.imageCache.object(forKey: photoModel.largeImageURL as NSString) == nil,
//                                cell.imageView.image == UIImage(named: "placeholder") {
//
//                            }
                            cell.configure(image: image)
                        }
                        self?.imageCache.setObject(image, forKey: photoModel.largeImageURL as NSString)
                    }
                }
            }
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell: PhotoCollectionViewCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            guard let image = cell.imageView.image else {
                return
            }
            photoPickerDelegate?.photoPickerController(self, didFinishPickingImage: image)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (self.numberOfItemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / numberOfItemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
