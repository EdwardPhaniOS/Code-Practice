//
//  ManagedCache.swift
//  Case_Study
//
//  Created by Vinh Phan on 30/10/24.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}
