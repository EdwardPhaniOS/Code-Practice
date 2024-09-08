//
//  FeedStore.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

protocol FeedStore {
    func retrive() throws -> CachedFeed
}
