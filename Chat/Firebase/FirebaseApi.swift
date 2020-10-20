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
    
    func loadChannels(completion: @escaping ([Channel]?,_ error: String?) -> Void) {
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
                        var lastActivity: Date? = nil
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
        channelsReference.addDocument(data: ["name": name, "lastActivity": Timestamp.init(date: Date())]) { (error) in
            completion(error == nil)
        }
    }
}
