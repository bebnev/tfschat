//
//  CoreDataStack.swift
//  Chat
//
//  Created by Anton Bebnev on 29.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var handleDataUpdate: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("document path not found")
        }
        print(documentsUrl.path)
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managed object model could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return context
    }
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait { [weak self] in
            block(context)
            
            if context.hasChanges {
                do {
                    try self?.performSaveInContext(context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
        
    func performSaveInContext(_ context: NSManagedObjectContext) throws {
        try context.save()
        
        if let parent = context.parent {
            try performSaveInContext(parent)
        }
    }
    
    func enableObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectDidChange),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: mainContext)
    }
    
    @objc
    private func managedObjectDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        handleDataUpdate?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            let channelsInserts = inserts.filter { (obj) -> Bool in
                return obj is Channel_db
            }
            
            let messagesInserts = inserts.filter { (obj) -> Bool in
                return obj is Message_db
            }
            
            if channelsInserts.count > 0 {
                print("Добавлено \(channelsInserts.count) объектов типа \(Channel_db.self)")
            }
            
            if messagesInserts.count > 0 {
                print("Добавлено \(messagesInserts.count) объектов типа \(Message_db.self)")
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            let channelsUpdates = updates.filter { (obj) -> Bool in
                return obj is Channel_db
            }
            
            let messagesUpdates = updates.filter { (obj) -> Bool in
                return obj is Message_db
            }
            
            if channelsUpdates.count > 0 {
                print("Изменено \(channelsUpdates.count) объектов типа \(Channel_db.self)")
            }
            
            if messagesUpdates.count > 0 {
                print("Изменено \(messagesUpdates.count) объектов типа \(Message_db.self)")
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            let channelsDeletes = deletes.filter { (obj) -> Bool in
                return obj is Channel_db
            }
            
            let messagesDeletes = deletes.filter { (obj) -> Bool in
                return obj is Message_db
            }
            
            if channelsDeletes.count > 0 {
               print("Удалено \(channelsDeletes.count) объектов типа \(Channel_db.self)")
            }
            
            if messagesDeletes.count > 0 {
                print("Удалено \(messagesDeletes.count) объектов типа \(Message_db.self)")
            }
            
        }
    }
    
    func printDatabaseStatistics() {
        mainContext.perform { [weak self] in
            do {
                let countChannels = try self?.mainContext.count(for: Channel_db.fetchRequest())
                print("\(String(describing: countChannels)) каналов")
                let channels = try self?.mainContext.fetch(Channel_db.fetchRequest()) as? [Channel_db] ?? []
                channels.forEach {
                    print($0.logString)
                }
                let countMessages = try self?.mainContext.count(for: Message_db.fetchRequest())
                print("\(String(describing: countMessages)) сообщений")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
