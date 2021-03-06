//
//  ITheme.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol ITheme {
    var mainBackgroundColor: UIColor { get }
    var mainTextColor: UIColor { get }
    var navigatioBackgroundColor: UIColor { get }
    var navigationTextColor: UIColor { get }
    var incomingCellBackgroundColor: UIColor { get }
    var outgoingCellBackgroundColor: UIColor { get }
    var onlineCellBackgroundColor: UIColor { get }
    var conversationsCellSubtitleColor: UIColor { get }
    var themeVCBackgroundColor: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var buttonBackgroundColor: UIColor { get }
    var searchBarBackgroundColor: UIColor { get }
    var tableViewSectionBackgroundColor: UIColor { get }
    var outgoingMessagesTextColor: UIColor { get }
    var navigationTintColor: UIColor { get }
    var chatInputFieldBackgroundColor: UIColor { get }
    var chatFieldBackgroundColor: UIColor { get }
    var chatFieldBorderColor: UIColor { get }
    var chatInputFieldBorderColor: UIColor { get }
    var chatInputPlaceholderColor: UIColor {get}
}
