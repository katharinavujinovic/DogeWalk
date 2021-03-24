//
//  DataController.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 22.03.21.
//

import Foundation
import CoreData

class DataController {
    
    static let dataController = DataController(modelName: "DogeWalk")
    let persistenceContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistenceContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistenceContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistenceContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
    
    func configureContexts() {
        backgroundContext = persistenceContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func saveViewContext() {
        try? viewContext.save()
    }
    
    func autoSaveViewContext(interval : TimeInterval = 30) {
        guard interval > 0 else {
            return
        }
        if viewContext.hasChanges {
            saveViewContext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
    
}
