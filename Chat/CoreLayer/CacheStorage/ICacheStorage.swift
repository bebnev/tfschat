//
//  ICacheStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol ICacheStorage {
    @discardableResult func save(key: String, data: Any) -> Bool
    @discardableResult func fetch(by key: String) -> Any?
    func canSave(by key: String) throws
}
