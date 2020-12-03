//
//  ChannelListViewController+ProfileViewControllerDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension ChannelListViewController: ProfileViewControllerDelegate {
    func profileDidUpdate() {
        guard let profile = presentationAssembly?.profileManager.profile else { return }
        if avatarView.userName != profile.name {
            avatarView.userName = profile.name
        }
    }
}
