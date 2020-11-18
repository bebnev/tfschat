//
//  CacheStorageErrors.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

enum CacheStorageErrorEnum: Error {
    case canNotInitializeStorage
    case isNotWritable
}
