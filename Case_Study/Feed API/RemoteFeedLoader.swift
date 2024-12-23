//
//  RemoteFeedLoaderService.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                do {
                    let feedImages = try FeedItemsMapper.map(data, response)
                    completion(.success(feedImages))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

}
