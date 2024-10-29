//
//  CoreDataFeedStore.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import CoreData

class CoreDataFeedStore: FeedStore {
    
    private static let modalName = ""
    private static let modal = NSManagedObjectModel.with(name: "FeedStore", bundle: Bundle(for: CoreDataFeedStore.self))
   
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modalNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init(storeUrl: URL) throws {
        guard let modal = CoreDataFeedStore.modal else {
            throw StoreError.modalNotFound
        }
        
        do {
            self.container = try NSPersistentContainer.load(name: CoreDataFeedStore.modalName, model: modal, url: storeUrl)
            self.context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    func cleanUpReferencesToPersistentStore() {
        context.performAndWait {
            let cordinator = self.container.persistentStoreCoordinator
            try? cordinator.persistentStores.forEach(cordinator.remove)
        }
    }
    
}
