//
//  IProfileServiceManager.swift
//  Chat
//
//  Created by Anton Bebnev on 12.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IProfileServiceManager {
    func save(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void)
    func fetchProfile(completion: @escaping ([String: Any]) -> Void)
}
