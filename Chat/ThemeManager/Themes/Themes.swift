//
//  Themes.swift
//  Chat
//
//  Created by Anton Bebnev on 07.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

enum Themes: Int {
    case classic = 1
    case day = 2
    case night = 3
    
    func getTheme() -> ThemeProtocol {
        switch self {
        case .classic:
            return ClassicTheme()
        case .night:
            return NightTheme()
        case .day:
            return DayTheme()
        }
    }
}
