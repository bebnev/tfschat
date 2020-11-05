//
//  DataProvider.swift
//  Chat
//
//  Created by Anton Bebnev on 04.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class DataManager {
    let coreDataStack: CoreDataStack
    lazy var db = Firestore.firestore()
    lazy var channelsReference = db.collection("channels")
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchChannels(completion: ((String?) -> Void)?) {
        self.channelsReference.addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                completion?(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                completion?("Can not get shanpshot documents")
                return
            }
            
            if snapshot.documentChanges.isEmpty {
                completion?(nil)
                return
            }
            
//            let docIds = snapshot.documentChanges.compactMap { $0.document.documentID }
//            let matchingRequest: NSFetchRequest<NSFetchRequestResult> = Channel_db.fetchRequest()
//            matchingRequest.predicate = NSPredicate(format: "NOT (identifier in %@)", argumentArray: [docIds])
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
//            
//             self?.coreDataStack.performSave({ (context) in
//                do {
//                    try context.executeAndMergeChanges(using: batchDeleteRequest)
//                } catch {
//                    print(error)
//                }
//                
//             })
            
            snapshot.documentChanges.forEach { (documentChange) in
                let channel = documentChange.document.data()
                switch documentChange.type {
                case .added:
                    self?.addChannelToDb(id: documentChange.document.documentID, data: channel)
                case .modified:
                    self?.updateChannelInDb(id: documentChange.document.documentID, data: channel)
                case .removed:
                    self?.removeChannelFromDb(id: documentChange.document.documentID)
                }
            }
            completion?(nil)
        }
    }
    
    func addChannel(name: String, completion: @escaping (String?) -> Void) {
        var ref: DocumentReference?
        ref = channelsReference.addDocument(data: ["name": name]) { (error) in
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                ref?.getDocument(completion: { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        completion(nil)
                        return
                    }
                    if error != nil {
                        completion(error?.localizedDescription)
                    } else if snapshot.data() != nil,
                            ref?.documentID != nil {
                        completion(nil)
                    } else {
                        completion("something went wrong")
                    }
                })
            }
        }
    }
    
    func removeChannel(withIdentifier id: String) {
        let channel = channelsReference.document(id)
        channel.delete { [weak self] error in
            if let error = error {
                print("Unable to delete a channel: \(error.localizedDescription)")
            } else {
                self?.removeChannelFromDb(id: id)
            }
        }
    }
    
    func fetchMessages(for id: String, completion: ((String?) -> Void)?) {
        let messageReference = channelsReference.document(id).collection("messages")

        messageReference.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                Log.debug(error.localizedDescription)
                completion?(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                completion?("Can not get shanpshot messages")
                return
            }
            if snapshot.documentChanges.isEmpty {
                completion?(nil)
                return
            }
            self?.coreDataStack.performSave({ (context) in
            snapshot.documentChanges.forEach { messageChange in
                let messageData = messageChange.document.data()
                switch messageChange.type {
                case .added:
                    self?.addMessageToDb(for: id, messageId: messageChange.document.documentID, data: messageData, context: context)
                default:
                    Log.debug("unrecognisable message firebase operation type")
                }
            }
                completion?(nil)
            })
            
        }
    }
    
    func addMessage(for channelId: String, data: [String: Any], completion: ((String?) -> Void)?) {
        let messageReference = channelsReference.document(channelId).collection("messages")
        
        messageReference.addDocument(data: data) { error in
            if let error = error {
                Log.debug(error.localizedDescription)
                completion?(error.localizedDescription)
            } else {
                completion?(nil)
            }
        }
    }
}

// MARK: - CoreData Channels

extension DataManager {
    private func removeChannelFromDb(id: String) {
        coreDataStack.performSave({ (context) in
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

    private func parseChannelDataToChannel(id: String, data: [String: Any]) -> Channel? {
        if let name = data["name"] as? String {
            let lastMessage = data["lastMessage"] as? String ?? nil
            var lastActivity: Date?
            if let time = data["lastActivity"] as? Timestamp {
                lastActivity = time.dateValue()
            }

            return Channel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
        }

        return nil
    }

    private func addChannelToDb(id: String, data: [String: Any]) {
        if let channel = parseChannelDataToChannel(id: id, data: data) {
            coreDataStack.performSave({ (context) in
                _ = channel.asCoreDataObject(in: context)
            })
        }
    }

    private func updateChannelInDb(id: String, data: [String: Any]) {
        if let channel = parseChannelDataToChannel(id: id, data: data) {
            coreDataStack.performSave({ (context) in
                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                let predicate = NSPredicate(format: "identifier = %@", id)
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
}

// MARK: - CoreData Messages
    
extension DataManager {
    private func parseMessageDataToMessage(id: String, data: [String: Any]) -> Message? {
        if let content = data["content"] as? String,
            let created = data["created"] as? Timestamp,
            let senderName = data["senderName"] as? String,
            let senderId = data["senderId"] as? String {

            return Message(identifier: id, content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
        }

        return nil
    }
    
    private func addMessageToDb(for channelId: String, messageId: String, data: [String: Any], context: NSManagedObjectContext) {
        if let message = parseMessageDataToMessage(id: messageId, data: data) {
            //coreDataStack.performSave({ (context) in
                let fetchRequest: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)

                let result = try? context.fetch(fetchRequest)

                if let channel = result?.first {
                    channel.addToMessages(message.asCoreDataObject(in: context))
                }
           //})
        }
    }
}
