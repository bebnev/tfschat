//
//  LoadNameOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class LoadNameOperation: BaseProfileOperation {
    var profileName: String?
    let completion: (Any?) -> Void
    
    init(profileStorage: IProfileStorage, completion: @escaping (Any?) -> Void) {
        self.completion = completion
        super.init(profileStorage: profileStorage)
    }
    
    override func main() {
        profileName = profileStorage.fetchName()
        completion(profileName)
        finish()
    }
}
