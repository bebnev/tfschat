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
    
    init(profile: Profile, about: String) {
        self.userAbout = about
        super.init(profile: profile)
    }
    
    override func main() {
        result = profile.saveAboutInfo(aboutInfo: userAbout)
        finish()
    }
}
