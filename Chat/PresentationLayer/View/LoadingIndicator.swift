//
//  LoadingIndicator.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {
    var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        isHidden = true
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator = activityIndicator
        addSubview(activityIndicator)
    }
    
    func start() {
        isHidden = false
        activityIndicator?.startAnimating()
    }
    
    func stop() {
        isHidden = true
        activityIndicator?.stopAnimating()
    }
}
