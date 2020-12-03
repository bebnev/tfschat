//
//  ViewControllerFactory.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class ViewControllerFactory: IViewControllerFactory {
    func makeTestViewController() -> TestViewController {
        return TestViewController.controllerFromStoryboard(.main, identifier: "TestViewController")
    }
}
