//
//  ProfileGCDDataManager.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ProfileServiceGCDManger: IProfileServiceManager {
    private var results = [String: Bool]()
    private let profileStorage: IProfileStorage
    
    init(profileStorage: IProfileStorage) {
        self.profileStorage = profileStorage
    }
    
    func fetchProfile(completion: @escaping ([String: Any]) -> Void) {
        completion([String: Any]())
    }
    
    func save(data: [String: Any], completion: @escaping ([String: Bool]) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.tfs_chat.profile.load", qos: .userInitiated, attributes: .concurrent)
        
        if data.keys.contains(UserFields.name.rawValue), let name = data[UserFields.name.rawValue] as? String {
            results[UserFields.name.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[UserFields.name.rawValue] = self?.profileStorage.saveName(name: name)
                group.leave()
            }
        }
        
        if data.keys.contains(UserFields.about.rawValue), let about = data[UserFields.about.rawValue] as? String {
            results[UserFields.about.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[UserFields.about.rawValue] = self?.profileStorage.saveAboutInfo(aboutInfo: about)
                group.leave()
            }
        }
        
        if data.keys.contains(UserFields.avatar.rawValue), let avatar = data[UserFields.avatar.rawValue] as? UIImage {
            results[UserFields.avatar.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[UserFields.avatar.rawValue] = self?.profileStorage.saveAvatar(avatar: avatar)
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            completion(self.results)
        }
    }
}
