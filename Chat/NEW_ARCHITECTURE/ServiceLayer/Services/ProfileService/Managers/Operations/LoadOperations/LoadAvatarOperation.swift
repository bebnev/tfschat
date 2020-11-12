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
    let completion: (Any?) -> Void
    
    init(profileStorage: IProfileStorage, completion: @escaping (Any?) -> Void) {
        self.completion = completion
        super.init(profileStorage: profileStorage)
    }
    
    override func main() {
        profileAvatar = profileStorage.fetchAvatar()
        completion(profileAvatar)
        finish()
    }
}
