//
//  ICacheStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol ICacheStorage {
    func save(key: String, data: Data) -> Bool
    func fetch(by key: String) -> Data?
    func canSave(by key: String) throws
}
