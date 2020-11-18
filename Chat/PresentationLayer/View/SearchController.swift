//
//  SearchController.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    var themeManager: IThemeManager?
    init(themeManager: IThemeManager?, searchResultsController: UIViewController?) {
        self.themeManager = themeManager
        super.init(searchResultsController: searchResultsController)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        obscuresBackgroundDuringPresentation = false
        searchBar.placeholder = "Search text"
        searchBar.textField?.backgroundColor = themeManager?.theme?.searchBarBackgroundColor
        searchBar.backgroundColor = .clear
    }
}
