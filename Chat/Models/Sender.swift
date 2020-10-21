//
//  UserId.swift
//  Chat
//
//  Created by Anton Bebnev on 21.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class Sender {
    private let userIdKey = "user_sender_id"
    static var shared = Sender()
    let name = "Anton Bebnev"
    var userId: String?
    
    func loadOrCreateSender() {
        guard let userId = UserDefaults.standard.value(forKey: userIdKey) as? String else {
            createUserId()
            return
        }
        
        self.userId = userId
    }
    
    private func createUserId() {
        DispatchQueue.global().async {[weak self] in
            guard let key = self?.userIdKey else {
                return
            }
            let uuid = UUID().uuidString
            self?.userId = uuid
            
            UserDefaults.standard.set(uuid, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}
