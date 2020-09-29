//
//  FakeDataLoader.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class FakeDataLoader {
    var conversations = [ConversationsModel]()
    
    func load() {
        if let fileLocation = Bundle.main.url(forResource: "conversations", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let conversations = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions()) as? [[String: Any]]
                
                if let conversations = conversations,
                    !conversations.isEmpty {
                    
                    var originalConverstions = [ConversationCellModel]()
                    
                    conversations.forEach {
                        guard let conversation = ConversationCellModel.parse(json: $0) else {
                            return
                        }
                        
                        originalConverstions.append(conversation)
                    }
                    
                    let onlineConversations = originalConverstions.filter { (conversation) -> Bool in
                        return conversation.isOnline
                    }
                    let historyConversations = originalConverstions.filter { (conversation) -> Bool in
                        return !conversation.isOnline
                    }
                    
                    self.conversations = [
                        ConversationsModel(title: "Online", conversations: onlineConversations),
                        ConversationsModel(title: "History", conversations: historyConversations)
                    ]
                }
            } catch {
                print(error)
            }
        }
    }
}
