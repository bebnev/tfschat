//
//  LoadProfileOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class LoadProfileOperation: AsyncOperation {
    private let completion: ([String: Any]) -> Void
    private let queue: OperationQueue
    private var profileStorage: IProfileStorage
    private let loadNameOperation: LoadNameOperation
    private let loadAboutOperation: LoadAboutOperation
    private let loadAvatarOperation: LoadAvatarOperation
    
    init(profileStorage: IProfileStorage,
         queue: OperationQueue,
         completion: @escaping ([String: Any]) -> Void) {
        self.profileStorage = profileStorage
        self.completion = completion
        self.queue = queue
        loadNameOperation = LoadNameOperation(profileStorage: profileStorage)
        loadAboutOperation = LoadAboutOperation(profileStorage: profileStorage)
        loadAvatarOperation = LoadAvatarOperation(profileStorage: profileStorage)
        
        super.init()
        
        addDependency(loadNameOperation)
        addDependency(loadAboutOperation)
        addDependency(loadAvatarOperation)
        
        queue.addOperations([loadNameOperation, loadAboutOperation, loadAvatarOperation], waitUntilFinished: false)
    }
    
    override func main() {
        var results = [String: Any]()
        results[ProfileFields.name.rawValue] = loadNameOperation.profileName
        results[ProfileFields.about.rawValue] = loadAboutOperation.profileAbout
        results[ProfileFields.avatar.rawValue] = loadAvatarOperation.profileAvatar
        
        completion(results)
        
        finish()
        
    }
}
