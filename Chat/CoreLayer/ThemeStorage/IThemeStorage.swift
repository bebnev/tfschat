//
//  IThemeStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IThemeStorage {
    func save(_ themeId: Int, completion: (() -> Void)?)
    func fetchTheme() -> Int?
}
