//
//  ProfileDataManager.swift
//  Chat
//
//  Created by Anton Bebnev on 14.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol ProfileDataManager {
    func load(completion: @escaping () -> Void)
    
    func save(data: [String: Any], completion: @escaping (_ results: [String: Bool]) -> Void)
}
