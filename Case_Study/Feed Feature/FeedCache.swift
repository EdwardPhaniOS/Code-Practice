//
//  FeedCache.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}

