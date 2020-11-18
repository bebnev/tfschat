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
        
        if data.keys.contains(ProfileFields.name.rawValue), let name = data[ProfileFields.name.rawValue] as? String {
            results[ProfileFields.name.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[ProfileFields.name.rawValue] = self?.profileStorage.saveName(name: name)
                group.leave()
            }
        }
        
        if data.keys.contains(ProfileFields.about.rawValue), let about = data[ProfileFields.about.rawValue] as? String {
            results[ProfileFields.about.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[ProfileFields.about.rawValue] = self?.profileStorage.saveAboutInfo(aboutInfo: about)
                group.leave()
            }
        }
        
        if data.keys.contains(ProfileFields.avatar.rawValue), let avatar = data[ProfileFields.avatar.rawValue] as? UIImage {
            results[ProfileFields.avatar.rawValue] = false
            group.enter()
            queue.async { [weak self] in
                self?.results[ProfileFields.avatar.rawValue] = self?.profileStorage.saveAvatar(avatar: avatar)
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            completion(self.results)
        }
    }
}
