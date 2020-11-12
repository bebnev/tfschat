//
//  FileCacheStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class FileCacheStorage: ICacheStorage {
    
    let cacheDirectory: URL
    
    init() {
        guard let cacheDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else {
                fatalError(CacheStorageErrorEnum.canNotInitializeStorage.localizedDescription)
        }
        
        self.cacheDirectory = cacheDirectory
        
    }
    
    func save(key: String, data: Data) -> Bool {
        do {
            let filePath = getFilePath(filename: key)
            if !FileManager.default.fileExists(atPath: filePath.path) {
                FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            }
            try canSave(by: filePath.path)
            try data.write(to: filePath)
            return true
        } catch CacheStorageErrorEnum.canNotInitializeStorage {
            print("Не получается обработиться в директории .cache")
        } catch CacheStorageErrorEnum.isNotWritable {
            print("Запись в файл \(key) запрещена")
        } catch {
            print(error)
        }
        
        return false
    }
    
    func fetch(by key: String) -> Data? {
        do {
            let filePath = getFilePath(filename: key)
            
            if FileManager.default.fileExists(atPath: filePath.path)
                && FileManager.default.isReadableFile(atPath: filePath.path) {
                return try Data(contentsOf: filePath)
            }
        } catch {
            
        }
        
        return nil
    }
    
    func canSave(by key: String) throws {
        if !FileManager.default.isWritableFile(atPath: key) {
            throw CacheStorageErrorEnum.isNotWritable
        }
    }
    
    private func getFilePath(filename: String) -> URL {
        return cacheDirectory.appendingPathComponent("\(filename).log")
    }
    
}
