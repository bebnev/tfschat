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
    private var profile: Profile
    private var results = [String: Bool]()
    
    init(profile: Profile,
         queue: OperationQueue,
         data: [String: Any],
         completion: @escaping (_ result: [String: Bool]) -> Void) {
        self.profile = profile
        self.completion = completion
        self.queue = queue
        
        super.init()
        
        var operations = [Operation]()
        
        if data.keys.contains(UserFields.name.rawValue), let name = data[UserFields.name.rawValue] as? String {
            results[UserFields.name.rawValue] = false
            let saveNameOperation = SaveNameOperation(profile: profile, name: name)
            saveNameOperation.completionBlock = {
                self.results[UserFields.name.rawValue] = saveNameOperation.result
            }
            addDependency(saveNameOperation)
            operations.append(saveNameOperation)
        }
        
        if data.keys.contains(UserFields.about.rawValue), let about = data[UserFields.about.rawValue] as? String {
            results[UserFields.about.rawValue] = false
            let saveAboutOperation = SaveAboutOperation(profile: profile, about: about)
            saveAboutOperation.completionBlock = {
                self.results[UserFields.about.rawValue] = saveAboutOperation.result
            }
            addDependency(saveAboutOperation)
            operations.append(saveAboutOperation)
        }
//
        if data.keys.contains(UserFields.avatar.rawValue), let avatar = data[UserFields.avatar.rawValue] as? UIImage {
            results[UserFields.avatar.rawValue] = false
            let saveAvatarOperation = SaveAvatarOperation(profile: profile, avatar: avatar)
            saveAvatarOperation.completionBlock = {
                self.results[UserFields.avatar.rawValue] = saveAvatarOperation.result
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
