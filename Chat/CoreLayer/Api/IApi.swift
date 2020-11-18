//
//  IApi.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol IApi {
    func fetchChannels(completion: @escaping ([[String: Any]]?, [[String: Any]]?, [[String: Any]]?, String?) -> Void)
    func removeChannel(withIdentifier id: String, completion: @escaping (Error?) -> Void)
    func addChannel(name: String, completion: @escaping (String?) -> Void)
    func fetchMessages(for id: String, completion: @escaping ([[String: Any]]?, String?) -> Void)
    func addMessage(for channelId: String, data: [String: Any], completion: ((String?) -> Void)?)
}
