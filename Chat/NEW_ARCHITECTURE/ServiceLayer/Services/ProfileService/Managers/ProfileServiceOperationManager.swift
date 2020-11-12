//
//  ProfileManager.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class ProfileServiceOperationManager: IProfileServiceManager {
    let backQueue = OperationQueue()
    let commonQueue = OperationQueue()
    private let profileStorage: IProfileStorage
    
    init(profileStorage: IProfileStorage) {
        self.profileStorage = profileStorage
        backQueue.qualityOfService = .userInitiated
        commonQueue.qualityOfService = .userInitiated
    }
    
    public func fetchProfile(completion: @escaping ([String: Any]) -> Void) {
        let loadOperation = LoadProfileOperation(profileStorage: profileStorage, queue: backQueue, completion: completion)
        commonQueue.addOperation(loadOperation)
    }
    
    public func save(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void) {
        let saveOperation = SaveProfileOperation(profileStorage: profileStorage, queue: backQueue, data: data, completion: completion)
        commonQueue.addOperation(saveOperation)
    }
    
}
