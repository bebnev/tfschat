//
//  LoadAvatarOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class LoadAvatarOperation: BaseProfileOperation {
    var profileAvatar: UIImage?
    
    override func main() {
        profileAvatar = profileStorage.fetchAvatar()
        finish()
    }
}
