//
//  ViewControllerFactory.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ViewControllerFactory: IViewControllerFactory {
    let presentationAssembly: IPresentationAssembly
    let servicesAssembly: IServicesAssembly
    
    init(presentationAssembly: IPresentationAssembly, servicesAssembly: IServicesAssembly) {
        self.presentationAssembly = presentationAssembly
        self.servicesAssembly = servicesAssembly
    }
    
    func makeChannelListViewController() -> ChannelListViewController {
        let controller = ChannelListViewController.controllerFromStoryboard(.main, identifier: "ChannelListViewController")
        
        controller.presentationAssembly = presentationAssembly
        controller.dataService = presentationAssembly.dataService
        
        return controller
    }
    
    func makeThemeListViewController() -> ThemeListViewController {
        let controller = ThemeListViewController(presentationAssembly: presentationAssembly)
        
        return controller
    }
    
    func makeProfileViewController() -> ProfileViewController {
        let controller = ProfileViewController.controllerFromStoryboard(.main, identifier: "ProfileViewController")
        
        controller.presentationAssembly = presentationAssembly
        
        return controller
    }
    
    func makeConversationViewController() -> ConversationViewController {
        let controller = ConversationViewController(presentationAssembly: presentationAssembly)
        
        controller.dataService = presentationAssembly.dataService
        
        return controller
    }
    
    func makeChoosePhotoViewController() -> PhotoViewController {
        let controller = PhotoViewController.controllerFromStoryboard(.main, identifier: "PhotoViewController")
        let model = PhotosModel(photosService: servicesAssembly.photosService)
        model.delegate = controller
        controller.model = model
        controller.presentationAssembly = presentationAssembly
        
        return controller
    }
}
