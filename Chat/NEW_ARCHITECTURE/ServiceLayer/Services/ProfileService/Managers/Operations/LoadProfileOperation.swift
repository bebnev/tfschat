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
    private var results = [String: Any]()
    
    init(profileStorage: IProfileStorage,
         queue: OperationQueue,
         completion: @escaping ([String: Any]) -> Void) {
        self.profileStorage = profileStorage
        self.completion = completion
        self.queue = queue
        
        super.init()
        
        let loadNameOperation = LoadNameOperation(profileStorage: profileStorage, completion: { (_) in
//            guard let name = profileName as? String else { return }
//            self?.results[UserFields.name.rawValue] = name
        })
        
        let loadAboutOperation = LoadAboutOperation(profileStorage: profileStorage, completion: { (_) in
//            guard let about = profileAbout as? String else { return }
//            self?.results[UserFields.about.rawValue] = about
        })
        
        let loadAvatarOperation = LoadAvatarOperation(profileStorage: profileStorage, completion: { (_) in
            //self?.results[UserFields.avatar.rawValue] = profileAvatar as? UIImage
        })
        
        addDependency(loadNameOperation)
        addDependency(loadAboutOperation)
        addDependency(loadAvatarOperation)
        
        queue.addOperations([loadNameOperation, loadAboutOperation, loadAvatarOperation], waitUntilFinished: false)
    }
    
    override func main() {
        finish()
        // TODO: crash
        completion([String: Any]())
    }
}
