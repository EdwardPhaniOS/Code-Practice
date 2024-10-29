//
//  FeedStore.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

protocol FeedStore {
    
    func insert(completion: (Result<Void, Error>) -> Void)
    
    func deleteCachedFeed(completion: (Result<Void, Error>) -> Void)
    
    func retrive(completion: (Result<CachedFeed, Error>) -> Void)
}
