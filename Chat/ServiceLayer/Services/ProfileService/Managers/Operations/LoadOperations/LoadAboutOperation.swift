//
//  LoadAboutOperation.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class LoadAboutOperation: BaseProfileOperation {
    var profileAbout: String?
    
    override func main() {
        profileAbout = profileStorage.fetchAboutInfo()
        finish()
    }
}
