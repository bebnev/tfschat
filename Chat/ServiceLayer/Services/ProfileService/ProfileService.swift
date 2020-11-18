//
//  ProfileService.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IProfileService {
    func save(completion: ((String?) -> Void)?)
    func fetch() -> String?
}

class ProfileService: IProfileService {
    let profileIdStorage: ICacheStorage
    let key = "user_sender_id"
    
    init(profileIdStorage: ICacheStorage) {
        self.profileIdStorage = profileIdStorage
    }
    
    func save(completion: ((String?) -> Void)?) {
        if fetch() != nil {
            completion?(nil)
            return
        }
        
        let profileId = UUID().uuidString
        
        DispatchQueue.global().async { [weak self] in
            if let key = self?.key {
                self?.profileIdStorage.save(key: key, data: profileId)
            }
            
            completion?(profileId)
        }
    }
    
    func fetch() -> String? {
        guard let profileId = profileIdStorage.fetch(by: key) as? String else {
            return nil
        }
        
        return profileId
    }
}
