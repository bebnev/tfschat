//
//  SaveAboutOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class SaveAboutOperation: BaseProfileOperation {
    let userAbout: String
    var result = false
    
    init(profileStorage: IProfileStorage, about: String) {
        self.userAbout = about
        super.init(profileStorage: profileStorage)
    }
    
    override func main() {
        result = profileStorage.saveAboutInfo(aboutInfo: userAbout)
        finish()
    }
}
