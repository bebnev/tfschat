//
//  FirebaseApi.swift
//  Chat
//
//  Created by Anton Bebnev on 13.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase

class FirebaseApi: IApi {
    lazy var db = Firestore.firestore()
    lazy var channelsReference = db.collection("channels")
    
    func fetchChannels(completion: @escaping ([[String: Any]]?, [[String: Any]]?, [[String: Any]]?, String?) -> Void) {
        self.channelsReference.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, nil, nil, error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil, nil, nil, "Can not get shanpshot documents")
                return
            }
            
            if snapshot.documentChanges.isEmpty {
                completion(nil, nil, nil, nil)
                return
            }
            
            var documentToAdd = [[String: Any]]()
            var documentToModify = [[String: Any]]()
            var documentToRemove = [[String: Any]]()
            
            snapshot.documentChanges.forEach { (documentChange) in
                var channel = documentChange.document.data()
                channel["id"] = documentChange.document.documentID
                switch documentChange.type {
                case .added:
                    documentToAdd.append(channel)
                case .modified:
                    documentToModify.append(channel)
                case .removed:
                    documentToRemove.append(channel)
                }
            }
            completion(documentToAdd, documentToModify, documentToRemove, nil)
        }
    }
    
    func removeChannel(withIdentifier id: String, completion: @escaping (Error?) -> Void) {
        let channel = channelsReference.document(id)
        channel.delete { error in
            completion(error)
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
    
    func fetchMessages(for id: String, completion: @escaping ([[String: Any]]?, String?) -> Void) {
        let messageReference = channelsReference.document(id).collection("messages")

        messageReference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {
                completion(nil, "Can not get shanpshot messages")
                return
            }
            if snapshot.documentChanges.isEmpty {
                completion(nil, nil)
                return
            }
            
            var addedMessages = [[String: Any]]()
            
            snapshot.documentChanges.forEach { messageChange in
                var messageData = messageChange.document.data()
                messageData["identifier"] = messageChange.document.documentID
                messageData["channelId"] = id
                switch messageChange.type {
                case .added:
                    addedMessages.append(messageData)
                default:
                    print("unrecognisable message firebase operation type")
                }
            }
            
            completion(addedMessages, nil)
            
        }
    }
    
    func addMessage(for channelId: String, data: [String: Any], completion: ((String?) -> Void)?) {
        let messageReference = channelsReference.document(channelId).collection("messages")
        
        messageReference.addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                completion?(error.localizedDescription)
            } else {
                completion?(nil)
            }
        }
    }
}
