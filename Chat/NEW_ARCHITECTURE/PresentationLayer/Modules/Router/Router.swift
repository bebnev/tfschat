//
//  Router.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class Router: IRouter {
    private let rootController: UINavigationController
    
    init(rootController: UIViewController) {
        self.rootController = UINavigationController(rootViewController: rootController)
    }
    
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?) {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else {
            return
        }
        
        rootController.pushViewController(controller, animated: animated)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
    
    func toPresent() -> UINavigationController {
        return rootController
    }
    
    func present(_ alert: UIAlertController) {
        rootController.present(alert, animated: true, completion: nil)
    }
}
