//
//  UserDefaultsThemeStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class UserDefaultsThemeStorage: IThemeStorage {
    private let userThemeKey = "user_theme_key"
    
    func save(_ themeId: Int, completion: (() -> Void)?) {
        DispatchQueue.global().async {[weak self] in
            guard let key = self?.userThemeKey else {
                return
            }
            
            UserDefaults.standard.set(themeId, forKey: key)
            UserDefaults.standard.synchronize()
            completion?()
        }
    }
    
    func fetchTheme() -> Int? {
        guard let themeId = UserDefaults.standard.value(forKey: userThemeKey) as? Int else {
            return nil
        }
        
        return themeId
    }
    
}
