//
//  DarkTheme.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

struct NightTheme: ITheme {
    var outgoingMessagesTextColor: UIColor = UIColor.white
    var mainTextColor = UIColor.white
    var mainBackgroundColor = UIColor.black
    var navigatioBackgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
    var navigationTextColor = UIColor.white
    var incomingCellBackgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    var outgoingCellBackgroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    var conversationsCellSubtitleColor = UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
    var themeVCBackgroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    var statusBarStyle: UIStatusBarStyle = .lightContent
    var buttonBackgroundColor = UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
    var onlineCellBackgroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
    var searchBarBackgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    var tableViewSectionBackgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    var navigationTintColor = UIColor.white
    var chatInputFieldBackgroundColor = UIColor.black
    var chatFieldBackgroundColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
    var chatFieldBorderColor = UIColor(red: 0.231, green: 0.231, blue: 0.231, alpha: 1)
    var chatInputFieldBorderColor = UIColor(red: 0.651, green: 0.651, blue: 0.667, alpha: 1)
    var chatInputPlaceholderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
}
