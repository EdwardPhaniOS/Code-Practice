//
//  CoreDataHelpers.swift
//  Case_Study
//
//  Created by Vinh Phan on 29/10/24.
//

import CoreData

extension NSManagedObjectModel {
    static func with(name: String, bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let containter = NSPersistentContainer(name: name, managedObjectModel: model)
        containter.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        containter.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return containter
    }
}
