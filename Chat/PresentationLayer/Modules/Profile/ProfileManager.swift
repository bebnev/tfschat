//
//  ProfileManager.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IProfileManager {
    var profile: ProfileModel? {get set}
    func fetchWithOperation(completion: (() -> Void)?)
    func saveWithOperation(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void)
    func saveWithGCD(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void)
}

class ProfileManager: IProfileManager {
    private let profileServiceOperation: IProfileServiceManager
    private let profileServiceGCD: IProfileServiceManager
    private let profileService: IProfileService
    var profile: ProfileModel?
    
    init(profileServiceOperation: IProfileServiceManager, profileServiceGCD: IProfileServiceManager, profileService: IProfileService) {
        self.profileServiceOperation = profileServiceOperation
        self.profileServiceGCD = profileServiceGCD
        self.profileService = profileService
    }
    
    func fetchWithOperation(completion: (() -> Void)?) {
        if let profileId = profileService.fetch() {
            fetchWith(profileId: profileId, completion: completion)
        } else {
            profileService.save { [weak self] (profileId) in
                guard let profileId = profileId else {
                    completion?()
                    return
                }
                
                self?.fetchWith(profileId: profileId, completion: completion)
            }
        }
    }
    
    private func fetchWith(profileId: String, completion: (() -> Void)?) {
        profileServiceOperation.fetchProfile { [weak self] (result) in
            if result.isEmpty {
                let profile = ProfileModel(id: profileId, name: "Anton Bebnev", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
                self?.profile = profile
                self?.saveWithOperation(
                    data: ["name": profile.name, "about": profile.about, "avatar": profile.avatar as Any], completion: { (_) in }
                )
            } else if let name = result[ProfileFields.name.rawValue] as? String,
                        let about = result[ProfileFields.about.rawValue] as? String {
                    let avatar = result[ProfileFields.avatar.rawValue] as? UIImage

                self?.profile = ProfileModel(id: profileId, name: name, about: about, avatar: avatar)
            }

            completion?()
        }
    }
    
    func saveWithOperation(data: [String: Any], completion: @escaping ([String: Bool]) -> Void) {
        profileServiceOperation.save(data: data) { [weak self] (results) in
            self?.updateProfileModel(with: data, and: results)
            completion(results)
        }
    }
    
    func saveWithGCD(data: [String: Any], completion: @escaping ([String: Bool]) -> Void) {
        profileServiceGCD.save(data: data) { [weak self] (results) in
            self?.updateProfileModel(with: data, and: results)
            completion(results)
        }
    }
    
    private func updateProfileModel(with data: [String: Any], and results: [String: Bool]) {
        
        guard let profile = profile else {return}
        
        let name: String
        if let nameIsSaved = results[ProfileFields.name.rawValue],
            nameIsSaved == true,
            let _name = data[ProfileFields.name.rawValue] as? String {
            name = _name
        } else {
            name = profile.name
        }
        
        var about: String
        if let aboutIsSaved = results[ProfileFields.about.rawValue],
            aboutIsSaved == true,
            let _about = data[ProfileFields.about.rawValue] as? String {
            about = _about
        } else {
            about = profile.about
        }
        
        let avatarIsSaved = results[ProfileFields.avatar.rawValue] ?? false
        let avatar = avatarIsSaved ? data[ProfileFields.avatar.rawValue] as? UIImage : profile.avatar
        
        self.profile = ProfileModel(id: profile.id, name: name, about: about, avatar: avatar)
    }
}
