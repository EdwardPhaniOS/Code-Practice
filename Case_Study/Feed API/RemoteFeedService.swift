//
//  RemoteFeedService.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

class RemoteFeedService: FeedService {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        client.get(from: FeedEndPoint.list.url) { result in
            switch result {
            case let .success((data, response)):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func save(item: FeedItem, completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: item.toSaveObject)
            client.post(to: FeedEndPoint.save.url, data: data) { result in
                switch result {
                case .success:
                    completion(.success(Void()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

}
