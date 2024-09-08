//
//  LocalFeedLoader.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

class LocalFeedLoader: FeedLoader {
    
    let feedStore: FeedStore
    
    init(feedStore: FeedStore) {
        self.feedStore = feedStore
    }
    
    func load(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        //TODO:
    }

}
