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
    
    init?(theme: ITheme) {
        switch theme {
        case is ClassicTheme:
            self = .classic
        case is NightTheme:
            self = .night
        case is DayTheme:
            self = .day
        default:
            return nil
        }
    }
    
    func getTheme() -> ITheme {
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
