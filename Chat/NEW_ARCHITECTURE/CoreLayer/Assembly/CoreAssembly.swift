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
    var themeStorage: IThemeStorage { get }
    var profileStorage: IProfileStorage { get }
    var cacheStorage: ICacheStorage { get }
    var coreDataStack: ICoreDataStack {get}
    var api: IApi {get}
}

class CoreAssembly: ICoreAssembly {
    var logProviders: [ILogProvider] = [ConsoleLogProvider()]
    var themeStorage: IThemeStorage = UserDefaultsThemeStorage()
    var cacheStorage: ICacheStorage = FileCacheStorage()
    lazy var profileStorage: IProfileStorage = ProfileStorage(cacheStorage: self.cacheStorage)
    lazy var coreDataStack: ICoreDataStack = CoreDataStack()
    lazy var api: IApi = FirebaseApi()
}
