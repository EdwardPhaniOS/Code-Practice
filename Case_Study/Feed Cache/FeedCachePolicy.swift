//
//  FeedCachePolicy.swift
//  Case_Study
//
//  Created by Vinh Phan on 12/08/2024.
//

import Foundation

struct CachedFeed {
    let feed: [LocalFeedItem]
    let timestampt: Date
    
    init(feed: [LocalFeedItem], timestampt: Date) {
        self.feed = feed
        self.timestampt = timestampt
    }
}





