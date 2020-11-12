//
//  IThemeManager.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IThemeManager {
    var theme: ITheme? { get }
    var delegate: IThemeManagerDelegate? { get set }
    func load()
    func save(_ theme: ITheme)
}
