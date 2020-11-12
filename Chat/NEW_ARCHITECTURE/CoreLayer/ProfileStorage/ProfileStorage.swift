//
//  ProfileStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

enum ProfileKeys: String {
    case name = "tfs_profile_name"
    case about = "tfs_profile_about"
    case avatar = "tfs_profile_avatar"
}

class ProfileStorage: IProfileStorage {
    let cacheStorage: ICacheStorage
    
    init(cacheStorage: ICacheStorage) {
        self.cacheStorage = cacheStorage
    }
    
    func saveName(name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = trimmedName.data(using: .utf8) else {
            return false
        }
        
        return cacheStorage.save(key: ProfileKeys.name.rawValue, data: data)
    }
    
    func saveAboutInfo(aboutInfo: String) -> Bool {
        let trimmedAbout = aboutInfo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = trimmedAbout.data(using: .utf8) else {
            return false
        }
        
        return cacheStorage.save(key: ProfileKeys.about.rawValue, data: data)
    }
    
    func saveAvatar(avatar: UIImage) -> Bool {
        guard let data = avatar.pngData() else {
            return false
        }
        
        return cacheStorage.save(key: ProfileKeys.avatar.rawValue, data: data)
    }
    
    func fetchName() -> String? {
        return fetchString(by: ProfileKeys.name)
    }
    
    func fetchAboutInfo() -> String? {
        return fetchString(by: ProfileKeys.about)
    }
    
    func fetchAvatar() -> UIImage? {
        guard let data = cacheStorage.fetch(by: ProfileKeys.avatar.rawValue), let image = UIImage(data: data) else { return nil }
        
        return image
    }
    
    private func fetchString(by key: ProfileKeys) -> String? {
        guard let data = cacheStorage.fetch(by: key.rawValue), let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
}
