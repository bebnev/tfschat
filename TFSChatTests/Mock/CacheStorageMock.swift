//
//  CacheStorageMock.swift
//  TFSChatTests
//
//  Created by Anton Bebnev on 03.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//
@testable import TFSChat
import Foundation

final class CacheStorageMock: ICacheStorage {
    var callSaveCount = 0
    var callFetchCount = 0
    var savedData: [String: Any] = [:]
    
    func save(key: String, data: Any) -> Bool {
        callSaveCount += 1
        savedData[key] = data
        return true
    }
    
    func fetch(by key: String) -> Any? {
        callFetchCount += 1
        
        guard let value = savedData[key] else {
            return nil
        }
        
        return value
    }
}
