//
//  ChannelRequest.swift
//  Chat
//
//  Created by Anton Bebnev on 29.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import CoreData

struct ChannelRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func loadChannels(channels: [Channel]) {
        coreDataStack.performSave { (context) in
            do {
                let fetchRequest = Channel_db.fetchRequest() as NSFetchRequest<Channel_db>
                let channelsDb = try context.fetch(fetchRequest)

                for channelDb in channelsDb {
                    context.delete(channelDb)
                }
                
                for channel in channels {
                    _ = channel.asCoreDataObject(in: context)
                }
            } catch {
                Log.debug(error.localizedDescription)
            }
        }
    }
    
    func addChannel(channel: Channel) {
        coreDataStack.performSave { (context) in
            _ = channel.asCoreDataObject(in: context)
        }
    }
    
    func setMessages(for channel: Channel, messages: [Message]) {
        coreDataStack.performSave { (context) in
            do {
                let fetchRequest = Channel_db.fetchRequest() as NSFetchRequest<Channel_db>
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                let channelsDb = try context.fetch(fetchRequest)
                
                if let channelDb = channelsDb.first {
                    if let messagesFromChannel = channelDb.messages,
                        messagesFromChannel.count > 0 {

                        if let castedMessagesFromChannel = messagesFromChannel as? Set<Message_db> {
                            for messageFromChannel in castedMessagesFromChannel {
                                context.delete(messageFromChannel)
                            }
                        }
                        
                       channelDb.removeFromMessages(messagesFromChannel)
                    }
                    
                    for message in messages {
                        channelDb.addToMessages(message.asCoreDataObject(in: context))
                    }
                    
                } else {
                    assertionFailure("Can not get channel_db")
                }
                
            } catch {
                Log.debug(error.localizedDescription)
            }
        }
    }
}
