//
//  FirebaseApi.swift
//  Chat
//
//  Created by Anton Bebnev on 20.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase

class FireBaseApi {
    static var shared = FireBaseApi()
    
    lazy var db = Firestore.firestore()
    lazy var channelsReference = db.collection("channels")
    
    func loadChannels(completion: @escaping (_ channels: [Channel]?, _ error: String?) -> Void) {
        channelsReference.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(nil, "Can not read snapshot")
                return
            }
            
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                let documents = snapshot.documents.sorted { (firstDocument, secondDocument) -> Bool in
                    let firstData = firstDocument.data()
                    let secondData = secondDocument.data()
                    
                    let firstDate = (firstData["lastActivity"] as? Timestamp)?.seconds ?? 0
                    let secondDate = (secondData["lastActivity"] as? Timestamp)?.seconds ?? 0
                    
                    return firstDate > secondDate
                }
                
                if documents.isEmpty {
                    completion([], nil)
                    return
                }
                
                var channels = [Channel]()
                
                for document in documents {
                    let documentData = document.data()
                    if let name = documentData["name"] as? String {
                        let lastMessage = documentData["lastMessage"] as? String ?? nil
                        var lastActivity: Date?
                        if let time = documentData["lastActivity"] as? Timestamp {
                            lastActivity = time.dateValue()
                        }
                        let channel = Channel(identifier: document.documentID, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
                        channels.append(channel)
                    }
                }
                
                completion(channels, nil)
            }
        }
    }
    
    func addChannel(name: String, completion: @escaping (_ isOk: Bool) -> Void) {
        channelsReference.addDocument(data: ["name": name, "lastActivity": Timestamp(date: Date())]) { (error) in
            completion(error == nil)
        }
    }
    
    func getMessages(id: String, completion: @escaping (_ messages: [Message]?, _ error: String?) -> Void) {
        let reference = db.collection("channels/\(id)/messages").order(by: "created")
        
        reference.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(nil, "Can not read snapshot")
                return
            }
            
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                let documents = snapshot.documents
                
                if documents.isEmpty {
                    completion([], nil)
                    return
                }
                
                var messages = [Message]()

                for document in documents {
                    let documentData = document.data()
                    if let content = documentData["content"] as? String,
                        let created = documentData["created"] as? Timestamp,
                        let senderName = documentData["senderName"] as? String,
                        let senderId = documentData["senderId"] as? String {
                        
                        let message = Message(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
                        messages.append(message)
                    }
                }

                completion(messages, nil)
            }
        }
    }
    
    func subscribeToMessages(id: String, completion: @escaping (_ messages: [Message]?, _ error: String?) -> Void) -> ListenerRegistration {
        let reference = db.collection("channels/\(id)/messages").order(by: "created")
        
        let listener = reference.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(nil, "Can not read snapshot")
                return
            }
            
            print("SUBSRIPTION")
            
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                let documents = snapshot.documents
                
                if documents.isEmpty {
                    print("EMPTY")
                    completion([], nil)
                    return
                }
                
                var messages = [Message]()

                for document in documents {
                    let documentData = document.data()
                    if let content = documentData["content"] as? String,
                        let created = documentData["created"] as? Timestamp,
                        let senderName = documentData["senderName"] as? String,
                        let senderId = documentData["senderId"] as? String {
                        
                        let message = Message(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName)
                        messages.append(message)
                    }
                }

                completion(messages, nil)
            }
        }
        
        return listener
    }
    
    func addMessage(channelId: String, message: Message, completion: ((_ isOk: Bool) -> Void)?) {
        let reference = db.collection("channels/\(channelId)/messages")
        
        reference.addDocument(data: message.asDictionary()) { (error) in
            completion?(error == nil)
        }
        
    }
}
