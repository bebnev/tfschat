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
    var profile: ProfileModel?
    
    init(profileServiceOperation: IProfileServiceManager, profileServiceGCD: IProfileServiceManager) {
        self.profileServiceOperation = profileServiceOperation
        self.profileServiceGCD = profileServiceGCD
    }
    
    func fetchWithOperation(completion: (() -> Void)?) {
        profileServiceOperation.fetchProfile { [weak self] (_) in
            // temporary faked
            
            self?.profile = ProfileModel(name: "Anton Bebnev", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
//            if result.isEmpty {
//                let profile = ProfileModel(name: "Anton Bebnev", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
//                self?.profile = profile
//                self?.saveWithOperation(
//                    data: ["name": profile.name, "about": profile.about, "avatar": profile.avatar as Any], completion: { (_) in
//                    //
//                })
//            } else {
//                if let name = result[UserFields.name.rawValue] as? String,
//                    let about = result[UserFields.about.rawValue] as? String {
//                    let avatar = result[UserFields.avatar.rawValue] as? UIImage
//
//                    self?.profile = ProfileModel(name: name, about: about, avatar: avatar)
//                }
//            }
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
        
        let name: String
        if let nameIsSaved = results[UserFields.name.rawValue],
            nameIsSaved == true,
            let _name = data[UserFields.name.rawValue] as? String {
            name = _name
        } else {
            name = profile?.name ?? ""
        }
        
        var about: String
        if let aboutIsSaved = results[UserFields.about.rawValue],
            aboutIsSaved == true,
            let _about = data[UserFields.about.rawValue] as? String {
            about = _about
        } else {
            about = profile?.about ?? ""
        }
        
        let avatarIsSaved = results[UserFields.avatar.rawValue] ?? false
        let avatar = avatarIsSaved ? data[UserFields.avatar.rawValue] as? UIImage : profile?.avatar
        
        profile = ProfileModel(name: name, about: about, avatar: avatar)
    }
}
