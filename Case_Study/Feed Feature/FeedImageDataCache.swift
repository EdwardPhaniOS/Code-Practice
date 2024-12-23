//
//  FeedImageDataCache.swift
//  Case_Study
//
//  Created by Vinh Phan on 23/12/24.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
