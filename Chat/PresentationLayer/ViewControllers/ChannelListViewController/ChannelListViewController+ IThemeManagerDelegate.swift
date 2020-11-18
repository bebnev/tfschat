//
//  ChannelListViewController+ IThemeManagerDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ChannelListViewController: IThemeManagerDelegate {
    func theme(didApply theme: ITheme) {
        navigationController?.applyTheme(theme: theme)
        searchController.searchBar.textField?.backgroundColor = theme.searchBarBackgroundColor
        tableView.reloadData()
    }
    
}
