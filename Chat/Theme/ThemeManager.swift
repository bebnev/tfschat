//
//  Theme.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ThemeManager {
    var theme: ThemeProtocol?
    
    static var shared: ThemeManager = {
        return ThemeManager()
    }()
    
    func setTheme(theme: ThemeProtocol) {
        self.theme = theme
    }
}
