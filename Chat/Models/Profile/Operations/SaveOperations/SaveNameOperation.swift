//
//  SaveNameOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class SaveNameOperation: BaseProfileOperation {
    let userName: String
    var result = false
    
    init(profile: Profile, name: String) {
        self.userName = name
        super.init(profile: profile)
    }
    
    override func main() {
        result = profile.saveName(name: userName)
        
        finish()
    }
}
