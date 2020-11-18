//
//  IProfileStorage.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol IProfileStorage {
    func saveName(name: String) -> Bool
    func saveAboutInfo(aboutInfo: String) -> Bool
    func saveAvatar(avatar: UIImage) -> Bool
    func fetchName() -> String?
    func fetchAboutInfo() -> String?
    func fetchAvatar() -> UIImage?
}
