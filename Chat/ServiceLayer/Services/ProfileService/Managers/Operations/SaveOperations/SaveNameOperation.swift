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
    
    init(profileStorage: IProfileStorage, name: String) {
        self.userName = name
        super.init(profileStorage: profileStorage)
    }
    
    override func main() {
        result = profileStorage.saveName(name: userName)
        
        finish()
    }
}
