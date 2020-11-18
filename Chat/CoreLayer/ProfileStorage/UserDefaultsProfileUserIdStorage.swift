//
//  UserDefaultsProfileUserIdStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class UserDefaultsProfileUserIdStorage: IProfileUserIdStorage {
    private let key = "profile_user_id"
    
    func save(_ profileId: String, completion: (() -> Void)?) {
        DispatchQueue.global().async {[weak self] in
            guard let key = self?.key else {
                return
            }
            
            UserDefaults.standard.set(profileId, forKey: key)
            UserDefaults.standard.synchronize()
            completion?()
        }
    }
    
    func fetchProfileId() -> String? {
        guard let profileId = UserDefaults.standard.value(forKey: key) as? String else {
            return nil
        }
        
        return profileId
    }
}
