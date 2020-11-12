//
//  Profile.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

enum ProfileFilesystemError: Error {
    case JSONSerializationFailed
    case fileIsNotWritable
    case canNotGetCacheDirectory
}

class Profile {
    
    static var shared = Profile()
    
    private let nameFile = "tfs_profile_name.txt"
    private let aboutFile = "tfs_profile_about.txt"
    private let avatarFile = "tfs_profile_avatar.txt"
    private let defaultProfile = User(name: "Marina Dudarenko", about: "UX/UI designer, web-designer Moscow, Russia", avatar: nil)
    var currentUser = User()
    
    func isLoaded() -> Bool {
        return currentUser.name?.isEmpty == false
    }
}

// MARK: - Filesystem

extension Profile {
    private func getFilePath(filename: String) throws -> URL {
        guard let cacheDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else {
                throw ProfileFilesystemError.canNotGetCacheDirectory
        }
        
        return cacheDirectory.appendingPathComponent(filename)
    }
    
    private func isFileWritable(atPath path: String) throws {
        if !FileManager.default.isWritableFile(atPath: path) {
            throw ProfileFilesystemError.fileIsNotWritable
        }
    }
    
    public func saveName(name: String) -> Bool {
        let trimmedData = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = trimmedData.data(using: .utf8) else {
            Log.debug("Imposible to convert to Data object from name: \(name)")
            return false
        }
        
        let result = saveToFile(data: data, file: nameFile)
        
        if result {
            currentUser.name = trimmedData
        }
        
        return result
    }
    
    public func saveAboutInfo(aboutInfo: String) -> Bool {
        let trimmedData = aboutInfo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = trimmedData.data(using: .utf8) else {
            Log.debug("Imposible to convert to Data object from aboutInfo: \(aboutInfo)")
            return false
        }
        
        let result = saveToFile(data: data, file: aboutFile)
        
        if result {
            currentUser.about = trimmedData
        }
        
        return result
    }
    
    public func saveAvatar(avatar: UIImage) -> Bool {
        guard let data = avatar.pngData() else {
            Log.debug("Imposible to convert to Data object from image")
            return false
        }
        
        let result = saveToFile(data: data, file: avatarFile)
        
        if result {
            currentUser.avatar = avatar
        }
        
        return result
    }
    
    private func saveToFile(data: Data, file: String) -> Bool {
        do {
            let filePath = try getFilePath(filename: file)
            try isFileWritable(atPath: filePath.path)
            try data.write(to: filePath)
            return true
        } catch ProfileFilesystemError.canNotGetCacheDirectory {
            print("Не получается обработиться в директории .cache")
        } catch ProfileFilesystemError.fileIsNotWritable {
            print("Запись в файл \(file) запрещена")
        } catch {
            print(error)
        }
        
        return false
    }
    
    public func loadNameFromFile() {
        guard let data = loadDataFromFile(file: nameFile) else { // TODO: fake for initial data
            return
        }
        
        currentUser.name = String(data: data, encoding: .utf8)
    }
    
    public func loadAboutInfoFromFile() {
        guard let data = loadDataFromFile(file: aboutFile) else { // TODO: fake for initial data
            return
        }
        
        currentUser.about = String(data: data, encoding: .utf8)
    }
    
    public func loadAvatarFromFile() {
        guard let data = loadDataFromFile(file: avatarFile) else { return }
        currentUser.avatar = UIImage(data: data)
    }
    
    private func loadDataFromFile(file: String) -> Data? {
        do {
            let filePath = try getFilePath(filename: file)
            
            if FileManager.default.fileExists(atPath: filePath.path)
                && FileManager.default.isReadableFile(atPath: filePath.path) {
                return try? Data(contentsOf: filePath)
            }
        } catch {
            Log.debug(error)
        }
        
        return nil
    }
    
    public func clear() {
        do {
            let nameFilePath = try getFilePath(filename: nameFile)
            let aboutFilePath = try getFilePath(filename: aboutFile)
            let avatarFilePath = try getFilePath(filename: avatarFile)
            
            [nameFilePath, aboutFilePath, avatarFilePath].forEach { (file) in
                if FileManager.default.fileExists(atPath: file.path) {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        } catch {
            Log.debug(error)
        }
    }
    
    public func loadInitialData() {
        do {
            let nameFilePath = try getFilePath(filename: nameFile)
            let aboutFilePath = try getFilePath(filename: aboutFile)
            let avatarFilePath = try getFilePath(filename: avatarFile)
            
            [(nameFilePath, defaultProfile.name), (aboutFilePath, defaultProfile.about), (avatarFilePath, nil)].forEach { (arg) in
                let (file, defaultValue) = arg
                
                if !FileManager.default.fileExists(atPath: file.path) {
                    FileManager.default.createFile(atPath: file.path, contents: defaultValue?.data(using: .utf8), attributes: nil)
                }
            }
            
        } catch {
            Log.debug(error)
        }
    }
}
