//
//  ViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class AbstractViewController: UIViewController {
    
    var layer: EmitterLayer?
    var presentationAssembly: IPresentationAssembly?
    var dataService: IDataService?
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layer = EmitterLayer(view: view)
        
        if let theme = presentationAssembly?.themeManager.theme {
            applyTheme(theme: theme)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        layer = nil
    }
    
    func applyTheme(theme: ITheme) {
        view.backgroundColor = theme.mainBackgroundColor
    }
}
