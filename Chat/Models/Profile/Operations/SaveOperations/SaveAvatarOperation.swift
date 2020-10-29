//
//  SaveAvatarOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class SaveAvatarOperation: BaseProfileOperation {
    let userAvatar: UIImage
    var result = false
    
    init(profile: Profile, avatar: UIImage) {
        self.userAvatar = avatar
        super.init(profile: profile)
    }
    
    override func main() {
        result = profile.saveAvatar(avatar: userAvatar)
        finish()
    }
}
