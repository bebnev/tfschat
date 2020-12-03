//
//  ServicesAssembly.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var logService: ILogService { get }
    var themeService: IThemeService { get }
    var profileServiceFactory: IProfileServiceFactory { get }
    var dataService: IDataService {get}
}

class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var logService: ILogService = LogServive(providers: self.coreAssembly.logProviders)
    lazy var themeService: IThemeService = ThemeService(themeStorage: self.coreAssembly.themeStorage)
    lazy var profileServiceFactory: IProfileServiceFactory = ProfileServiceFactory(profileStorage: self.coreAssembly.profileStorage)
    lazy var dataService: IDataService = DataService(coreData: self.coreAssembly.coreDataStack, api: self.coreAssembly.api)
}
