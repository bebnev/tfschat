//
//  UserDefaultsStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class UserDefaultsStorage: ICacheStorage {
    @discardableResult
    func save(key: String, data: Any) -> Bool {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
        
        return true
    }
    
    @discardableResult
    func fetch(by key: String) -> Any? {
        guard let data = UserDefaults.standard.value(forKey: key) else {
            return nil
        }
        
        return data
    }
    
    func canSave(by key: String) throws {}
}
