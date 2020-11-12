//
//  ProfileService.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IProfileServiceFactory {
    func makeGCDService() -> ProfileServiceGCDManger
    func makeOperationService() -> ProfileServiceOperationManager
}

class ProfileServiceFactory: IProfileServiceFactory {
    let profileStorage: IProfileStorage
    
    init(profileStorage: IProfileStorage) {
        self.profileStorage = profileStorage
    }
    
    func makeGCDService() -> ProfileServiceGCDManger {
        let service = ProfileServiceGCDManger(profileStorage: profileStorage)
        
        return service
    }
    
    func makeOperationService() -> ProfileServiceOperationManager {
        let service = ProfileServiceOperationManager(profileStorage: profileStorage)
        
        return service
    }
}
