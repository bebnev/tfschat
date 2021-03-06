//
//  IViewControllerFactory.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IViewControllerFactory {
    func makeChannelListViewController() -> ChannelListViewController
    func makeThemeListViewController() -> ThemeListViewController
    func makeProfileViewController() -> ProfileViewController
    func makeConversationViewController() -> ConversationViewController
    func makeChoosePhotoViewController() -> PhotoViewController
}
