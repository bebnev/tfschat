//
//  ClassicTheme.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

struct ClassicTheme: ITheme {
    var mainTextColor = UIColor.black
    var mainBackgroundColor = UIColor.white
    var navigatioBackgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    var navigationTextColor = UIColor.black
    var incomingCellBackgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    var outgoingCellBackgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    var conversationsCellSubtitleColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    var themeVCBackgroundColor = UIColor.white
    var statusBarStyle: UIStatusBarStyle = .default
    var buttonBackgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
    var onlineCellBackgroundColor = UIColor(red: 0.99, green: 1.00, blue: 0.82, alpha: 1)
    var searchBarBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
    var tableViewSectionBackgroundColor = UIColor(red: 0.968, green: 0.968, blue: 0.968, alpha: 1)
    var outgoingMessagesTextColor: UIColor = UIColor.black
    var navigationTintColor = UIColor(red: 0.329, green: 0.329, blue: 0.345, alpha: 0.65)
    var chatInputFieldBackgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
    var chatFieldBackgroundColor = UIColor.white
    var chatFieldBorderColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
    var chatInputFieldBorderColor = UIColor(red: 0.651, green: 0.651, blue: 0.667, alpha: 0.5)
    var chatInputPlaceholderColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
}
