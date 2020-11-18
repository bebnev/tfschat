//
//  IProfileUserIdStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IProfileUserIdStorage {
    func save(_ profileId: String, completion: (() -> Void)?)
    func fetchProfileId() -> String?
}
