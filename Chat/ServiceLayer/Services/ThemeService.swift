//
//  ThemeService.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IThemeService {
    func save(_ theme: ITheme, completion: (() -> Void)?)
    func fetchTheme() -> ITheme?
}

class ThemeService: IThemeService {
    let themeStorage: ICacheStorage
    let key = "user_theme_key"
    
    init(themeStorage: ICacheStorage) {
        self.themeStorage = themeStorage
    }
    
    func save(_ theme: ITheme, completion: (() -> Void)?) {
        guard let themeId = Themes(theme: theme) else {
            return
        }
        
        DispatchQueue.global().async {[weak self] in
            if let key = self?.key {
                self?.themeStorage.save(key: key, data: themeId.rawValue)
            }
            
            completion?()
        }
    }
    
    func fetchTheme() -> ITheme? {
        guard let themeId = themeStorage.fetch(by: key) as? Int, let theme = Themes(rawValue: themeId) else {
            return nil
        }
        
        return theme.getTheme()
    }
}
