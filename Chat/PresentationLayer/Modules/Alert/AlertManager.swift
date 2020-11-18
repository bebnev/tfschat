//
//  AlertManager.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IAlertManager {
    func alert(title: String) -> UIAlertController
    func alert(title: String, message: String?) -> UIAlertController
    func error(message: String) -> UIAlertController
    func error(title: String, message: String?) -> UIAlertController
    func error(message: String?, repeatAction: ((UIAlertAction) -> Void)?) -> UIAlertController
}

class AlertManager: IAlertManager {
    
    func alert(title: String) -> UIAlertController {
        return alert(title: title, message: nil)
    }
    
    func alert(title: String, message: String?) -> UIAlertController {
        return baseAlertController(title: title, message: message)
    }
    
    func error(message: String) -> UIAlertController {
        return baseAlertController(title: "Ошибка", message: message)
    }
    
    func error(title: String, message: String?) -> UIAlertController {
        return baseAlertController(title: title, message: message)
    }
    
    func error(message: String?, repeatAction: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController = baseAlertController(title: "Ошибка", message: message)
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .default, handler: repeatAction)
        alertController.addAction(tryAgainAction)
        
        return alertController
    }
    
    private func baseAlertController(title: String, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
}
