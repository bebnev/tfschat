//
//  DataService.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol IDataService {
    func fetchChannels(completion: ((String?) -> Void)?)
    func removeChannel(withIdentifier id: String)
    func getMainContext() -> NSManagedObjectContext
    func addChannel(name: String, completion: @escaping (String?) -> Void)
    func fetchMessages(for id: String, completion: ((String?) -> Void)?)
    func addMessage(for channelId: String, data: [String: Any], completion: ((String?) -> Void)?)
}

class DataService: IDataService {
    let coreData: ICoreDataStack
    let api: IApi
    
    init(coreData: ICoreDataStack, api: IApi) {
        self.coreData = coreData
        self.api = api
    }
    
    func fetchChannels(completion: ((String?) -> Void)?) {
        api.fetchChannels { [weak self] (channelsToAdd, channelsToModify, channelsToRemove, error) in
            if let error = error {
                completion?(error)
                return
            }
            
            self?.parseChannelChanges(channels: channelsToAdd, parser: self?.addChannelToDb)
            self?.parseChannelChanges(channels: channelsToModify, parser: self?.updateChannelInDb)
            self?.parseChannelChanges(channels: channelsToRemove, parser: self?.removeChannelFromDb)
        }
    }
    
    func getMainContext() -> NSManagedObjectContext {
        return self.coreData.mainContext
    }
    
    func removeChannel(withIdentifier id: String) {
        api.removeChannel(withIdentifier: id) { [weak self] error in
            if let error = error {
                print("Unable to delete a channel: \(error.localizedDescription)")
            } else {
                self?.removeChannelFromDb(id: id)
            }
        }
    }
    
    func addChannel(name: String, completion: @escaping (String?) -> Void) {
        api.addChannel(name: name) { (error) in
            completion(error)
        }
    }
    
    func fetchMessages(for id: String, completion: ((String?) -> Void)?) {
        api.fetchMessages(for: id) { [weak self] messages, error in
            if let error = error {
                completion?(error)
                return
            }
            
            if let messages = messages, messages.count > 0 {
                messages.forEach { (message) in
                    self?.addMessageToDb(data: message)
                }
            }
        }
    }
    
    func addMessage(for channelId: String, data: [String: Any], completion: ((String?) -> Void)?) {
        api.addMessage(for: channelId, data: data) { error in
            completion?(error)
        }
    }
    
    private func parseChannelChanges(channels: [[String: Any]]?, parser: (([String: Any]) -> Void)?) {
        if let channels = channels, channels.count > 0 {
            channels.forEach { (channel) in
                parser?(channel)
            }
        }
    }
    
    private func parseChannelDataToChannel(data: [String: Any]) -> Channel? {
        if  let id = data["id"] as? String,
            let name = data["name"] as? String {
            let lastMessage = data["lastMessage"] as? String ?? nil
            var lastActivity: Date?
            if let time = data["lastActivity"] as? Timestamp {
                lastActivity = time.dateValue()
            }

            return Channel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
        }

        return nil
    }
    
    private func addChannelToDb(data: [String: Any]) {
        if let channel = parseChannelDataToChannel(data: data) {
            coreData.performSave({ (context) in
                _ = channel.asCoreDataObject(in: context)
            })
        }
    }
    
    private func updateChannelInDb(data: [String: Any]) {
        if let channel = parseChannelDataToChannel(data: data) {
            coreData.performSave({ (context) in
                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                fetchRequest.predicate = predicate

                let result = try? context.fetch(fetchRequest)

                if let channelDb = result?.first {
                    if channelDb.value(forKey: "name") as? String != channel.name {
                        channelDb.setValue(channel.name, forKey: "name")
                    }

                    if channelDb.value(forKey: "lastMessage") as? String != channel.lastMessage {
                        channelDb.setValue(channel.lastMessage, forKey: "lastMessage")
                    }

                    if channelDb.value(forKey: "lastActivity") as? Date != channel.lastActivity {
                        channelDb.setValue(channel.lastActivity, forKey: "lastActivity")
                    }
                } else {
                    _ = channel.asCoreDataObject(in: context)
                }
            })
        }
    }
    
    private func removeChannelFromDb(id: String) {
        coreData.performSave({ (context) in
            let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", id)
            do {
                guard let object = try context.fetch(fetchRequest).first else {
                    return
                }
                context.delete(object)
            } catch {
                print(error)
            }
        })
    }
    
    private func removeChannelFromDb(data: [String: Any]) {
        if let channel = parseChannelDataToChannel(data: data) {
            removeChannelFromDb(id: channel.identifier)
        }
    }
    
    private func parseMessageDataToMessage(data: [String: Any]) -> Message? {
        if let id = data["identifier"] as? String,
            let content = data["content"] as? String,
            let created = data["created"] as? Timestamp,
            let senderName = data["senderName"] as? String,
            let senderId = data["senderId"] as? String {

            return Message(identifier: id, content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
        }

        return nil
    }
    
    private func addMessageToDb(data: [String: Any]) {
        if let message = parseMessageDataToMessage(data: data),
            let channelId = data["channelId"] as? String {
            coreData.performSave({ (context) in
                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)

                let result = try? context.fetch(fetchRequest)

                if let channel = result?.first {
                    channel.addToMessages(message.asCoreDataObject(in: context))
                }
            })
        }
    }
}
