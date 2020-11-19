//
//  PhotoViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class PhotoViewController: AbstractViewController {
    
    var model: IPhotosModel?
    weak var photoPickerDelegate: IPhotoViewControllerDelegate?
    internal let numberOfItemsPerRow: CGFloat = 3
    internal let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    internal var dataSource: Photos?
    internal let imageCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var loadingIndicator: LoadingIndicator = {
        let view = LoadingIndicator()
        view.center = self.view.center
        view.activityIndicator?.backgroundColor = .white
        
        return view
    }()
    
    internal var isLoading = false {
        didSet {
            if isLoading {
                loadingIndicator.start()
            } else {
                loadingIndicator.stop()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureCollectionView()
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoading = true
        model?.fetchPhotos()
    }
    
    func configureNavigation() {
        title = "Выберите фото"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(close))
    }
    
    func configureView() {
        view.addSubview(loadingIndicator)
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: String(describing: PhotoCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

}
