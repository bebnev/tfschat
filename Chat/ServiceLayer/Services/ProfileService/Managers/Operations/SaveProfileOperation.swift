//
//  SaveProfileOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class SaveProfileOperation: AsyncOperation {
    private let completion: (_ result: [String: Bool]) -> Void
    private let queue: OperationQueue
    private var profileStorage: IProfileStorage
    private var results = [String: Bool]()
    
    init(profileStorage: IProfileStorage,
         queue: OperationQueue,
         data: [String: Any],
         completion: @escaping (_ result: [String: Bool]) -> Void) {
        self.profileStorage = profileStorage
        self.completion = completion
        self.queue = queue
        
        super.init()
        
        var operations = [Operation]()
        
        if data.keys.contains(ProfileFields.name.rawValue), let name = data[ProfileFields.name.rawValue] as? String {
            results[ProfileFields.name.rawValue] = false
            let saveNameOperation = SaveNameOperation(profileStorage: profileStorage, name: name)
            saveNameOperation.completionBlock = { [weak self] in
                self?.results[ProfileFields.name.rawValue] = saveNameOperation.result
            }
            addDependency(saveNameOperation)
            operations.append(saveNameOperation)
        }
        
        if data.keys.contains(ProfileFields.about.rawValue), let about = data[ProfileFields.about.rawValue] as? String {
            results[ProfileFields.about.rawValue] = false
            let saveAboutOperation = SaveAboutOperation(profileStorage: profileStorage, about: about)
            saveAboutOperation.completionBlock = { [weak self] in
                self?.results[ProfileFields.about.rawValue] = saveAboutOperation.result
            }
            addDependency(saveAboutOperation)
            operations.append(saveAboutOperation)
        }
//
        if data.keys.contains(ProfileFields.avatar.rawValue), let avatar = data[ProfileFields.avatar.rawValue] as? UIImage {
            results[ProfileFields.avatar.rawValue] = false
            let saveAvatarOperation = SaveAvatarOperation(profileStorage: profileStorage, avatar: avatar)
            saveAvatarOperation.completionBlock = { [weak self] in
                self?.results[ProfileFields.avatar.rawValue] = saveAvatarOperation.result
            }
            addDependency(saveAvatarOperation)
            operations.append(saveAvatarOperation)
        }
        
        queue.addOperations(operations, waitUntilFinished: false)
    }
    
    override func main() {
        finish()
        completion(results)
    }
}
