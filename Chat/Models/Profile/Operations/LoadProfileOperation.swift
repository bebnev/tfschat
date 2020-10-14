//
//  LoadProfileOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class LoadProfileOperation: AsyncOperation {
    private let completion: () -> Void
    private let queue: OperationQueue
    private var profile: Profile
    
    init(profile: Profile,
         queue: OperationQueue,
         completion: @escaping () -> Void) {
        self.profile = profile
        self.completion = completion
        self.queue = queue
        
        let loadNameOperation = LoadNameOperation(profile: profile)
        let loadAboutOperation = LoadAboutOperation(profile: profile)
        let loadAvatarOperation = LoadAvatarOperation(profile: profile)
        
        super.init()
        
        addDependency(loadNameOperation)
        addDependency(loadAboutOperation)
        addDependency(loadAvatarOperation)
        
        queue.addOperations([loadNameOperation, loadAboutOperation, loadAvatarOperation], waitUntilFinished: false)
    }
    
    override func main() {
        finish()
        completion()
    }
}
