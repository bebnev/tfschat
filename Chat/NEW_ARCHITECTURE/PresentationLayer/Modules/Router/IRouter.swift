//
//  IRouter.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IRouter {
  
    func present(_ alert: UIAlertController)
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    //func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    //func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func toPresent() -> UINavigationController
}
