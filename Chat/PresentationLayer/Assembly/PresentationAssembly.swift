//
//  PresentationAssembly.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    var router: IRouter { get }
    var themeManager: IThemeManager { get set }
    var viewControllerFactory: IViewControllerFactory { get }
    var profileManager: IProfileManager { get }
    var alertManager: IAlertManager { get }
    var dataService: IDataService {get}
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    lazy var router: IRouter = Router(rootController: self.viewControllerFactory.makeChannelListViewController())
    lazy var themeManager: IThemeManager = ThemeManagerNew(themeService: self.serviceAssembly.themeService)
    lazy var viewControllerFactory: IViewControllerFactory = ViewControllerFactory(presentationAssembly: self, servicesAssembly: self.serviceAssembly)
    lazy var profileManager: IProfileManager = ProfileManager(
        profileServiceOperation: self.serviceAssembly.profileServiceFactory.makeOperationService(),
        profileServiceGCD: self.serviceAssembly.profileServiceFactory.makeGCDService(),
        profileService: self.serviceAssembly.profileSerive)
    lazy var alertManager: IAlertManager = AlertManager()
    lazy var dataService: IDataService = self.serviceAssembly.dataService
}
