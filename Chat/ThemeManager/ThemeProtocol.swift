//
//  ThemeProtocol.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    var mainBackgroundColor: UIColor { get }
    var mainTextColor: UIColor { get }
    var navigatioBackgroundColor: UIColor { get }
    var navigationTextColor: UIColor { get }
    var incomingCellBackgroundColor: UIColor { get }
    var outgoingCellBackgroundColor: UIColor { get }
    
    var conversationsLastMessageLabelColor: UIColor { get }
}
