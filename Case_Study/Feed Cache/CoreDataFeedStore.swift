//
//  CoreDataFeedStore.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import CoreData

class CoreDataFeedStore: FeedStore {
    
    
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func retrive() throws -> CachedFeed {
        //TODO:
        return CachedFeed(feed: [], timestampt: Date())
    }
}
