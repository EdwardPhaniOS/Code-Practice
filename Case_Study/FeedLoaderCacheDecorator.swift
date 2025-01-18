//
//  FeedLoaderCacheDecorator.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import Foundation

public final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (Result<[FeedImage], any Error>) -> Void) {
        decoratee.load { result in
            completion(result.map { [weak self] feed in
                self?.cache.saveIgnoringResult(feed)
                return feed
            })
        }
    }
}

private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
