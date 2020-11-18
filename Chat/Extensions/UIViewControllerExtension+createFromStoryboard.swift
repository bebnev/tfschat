//
//  UIViewControllerExtension+createFromStoryboard.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension UIViewController {
  
  class func controllerFromStoryboard(_ storyboardEnum: Storyboards, identifier: String) -> Self {
    let storyboard = UIStoryboard(name: storyboardEnum.rawValue, bundle: nil)
    guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
        fatalError("Can not create controller \(Self.description())")
    }
    
    return controller
  }
}
