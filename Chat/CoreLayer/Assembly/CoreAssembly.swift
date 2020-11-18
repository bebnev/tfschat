//
//  CoreAssembly.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var logProviders: [ILogProvider] { get }
    var themeStorage: ICacheStorage { get }
    var profileStorage: IProfileStorage { get }
    var fileCacheStorage: ICacheStorage { get }
    var coreDataStack: ICoreDataStack { get }
    var profileIdStorage: ICacheStorage { get }
    var api: IApi { get }
}

class CoreAssembly: ICoreAssembly {
    var logProviders: [ILogProvider] = [ConsoleLogProvider()]
    var themeStorage: ICacheStorage = UserDefaultsStorage()
    var fileCacheStorage: ICacheStorage = FileCacheStorage()
    var profileIdStorage: ICacheStorage = UserDefaultsStorage()
    lazy var profileStorage: IProfileStorage = ProfileStorage(cacheStorage: self.fileCacheStorage)
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var api: IApi = FirebaseApi()
}
