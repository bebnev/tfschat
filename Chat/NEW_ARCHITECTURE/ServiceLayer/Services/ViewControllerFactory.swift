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
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
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
}
