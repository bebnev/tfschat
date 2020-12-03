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
    let themeStorage: IThemeStorage
    
    init(themeStorage: IThemeStorage) {
        self.themeStorage = themeStorage
    }
    
    func save(_ theme: ITheme, completion: (() -> Void)?) {
        guard let themeId = Themes(theme: theme) else {
            return
        }
        
        themeStorage.save(themeId.rawValue, completion: completion)
    }
    
    func fetchTheme() -> ITheme? {
        guard let themeId = themeStorage.fetchTheme(), let theme = Themes(rawValue: themeId) else {
            return nil
        }
        
        return theme.getTheme()
    }
}
