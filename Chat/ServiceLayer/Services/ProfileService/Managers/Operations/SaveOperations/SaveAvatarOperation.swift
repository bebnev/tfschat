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
    
    init(profileStorage: IProfileStorage, avatar: UIImage) {
        self.userAvatar = avatar
        super.init(profileStorage: profileStorage)
    }
    
    override func main() {
        result = profileStorage.saveAvatar(avatar: userAvatar)
        finish()
    }
}
