//
//  User.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

enum ProfileFields: String {
    case name
    case about
    case avatar
    
    init?(field: String) {
        switch field {
        case "name":
            self = .name
        case "about":
            self = .about
        case "avatar":
            self = .avatar
        default:
            return nil
        }
    }
    
    func getFieldName() -> String {
        switch self {
        case .name:
            return "Имя пользователя"
        case .about:
            return "Информация о себе"
        case .avatar:
            return "Аватар"
        }
    }
}
