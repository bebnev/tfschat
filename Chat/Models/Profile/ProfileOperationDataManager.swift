//
//  ProfileManager.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class ProfileOperationDataManager: ProfileDataManager {
    let backQueue = OperationQueue()
    let commonQueue = OperationQueue()
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
        backQueue.qualityOfService = .userInitiated
        commonQueue.qualityOfService = .userInitiated
    }
    
    public func load(completion: @escaping () -> Void) {
        let loadInitialDataOperation = LoadInitialDataOperation(profile: profile)
        loadInitialDataOperation.completionBlock = {
            let loadOperation = LoadProfileOperation(profile: self.profile, queue: self.backQueue, completion: completion)
            self.commonQueue.addOperation(loadOperation)
        }
        
        commonQueue.addOperation(loadInitialDataOperation)
    }
    
    public func save(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void) {
        let saveOperation = SaveProfileOperation(profile: profile, queue: backQueue, data: data, completion: completion)
        commonQueue.addOperation(saveOperation)
    }
    
}
