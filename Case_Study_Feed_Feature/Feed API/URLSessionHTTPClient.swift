//
//  URLSessionHTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        executeRequest(request: request, completion: completion)
    }
    
    func post(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        executeRequest(request: request, completion: completion)
    }
    
    func put(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        executeRequest(request: request, completion: completion)
    }
    
    func delete(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        executeRequest(request: request, completion: completion)
    }
    
    func executeRequest(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
        }.resume()
    }
}

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
                case let .failure(error)
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

}





