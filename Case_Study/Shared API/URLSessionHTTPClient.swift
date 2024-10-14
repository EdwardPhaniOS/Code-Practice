//
//  URLSessionHTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    var accessToken: String?
    var isRefreshingToken: Bool = false
    var expirationDate: Date?
    var pendingRequest: [(Swift.Result<String, Error>) -> Void] = []
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        //Adapter pattern
        var dataTask: URLSessionDataTask?
        
        init(dataTask: URLSessionDataTask?) {
            self.dataTask = dataTask
        }
        
        func cancel() {
            dataTask?.cancel()
        }
    }
    
    @discardableResult
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return executeRequest(request: request, completion: completion)
    }
    
    @discardableResult
    func delete(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return executeRequest(request: request, completion: completion)
    }
    
    @discardableResult
    func post(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        return executeRequest(request: request, completion: completion)
    }
    
    @discardableResult
    func put(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        return executeRequest(request: request, completion: completion)
    }
    
    @discardableResult
    func executeRequest(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        printRequestDetail(request)
        
        if isTokenExpired() {
            refreshToken { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let newToken):
                    self.accessToken = newToken
                    self.executeRequest(request: request, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            return URLSessionTaskWrapper(dataTask: nil)
        }
        
        guard let token = accessToken
        else {
            completion(.failure(NSError(domain: "No token", code: 401)))
            return URLSessionTaskWrapper(dataTask: nil)
        }
        
        var updatedRequest = request
        updatedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: updatedRequest) { [weak self] data, response, error in
            self?.printResponseDetail(data: data, response: response, error: error)
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                }
            }
        }
        task.resume()
        
        return URLSessionTaskWrapper(dataTask: task)
    }
    
    private func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        if isRefreshingToken {
            pendingRequest.append(completion)
            return
        }
        
        isRefreshingToken = true
        
        //Simulate token refresh request
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.isRefreshingToken = false
            let newToken = "new_token"
            self?.accessToken = newToken
            
            self?.pendingRequest.forEach({ $0(.success(newToken)) })
            self?.pendingRequest.removeAll()
            
            completion(.success(newToken))
        })
    }
    
    private func isTokenExpired() -> Bool {
        guard let expirationDate = expirationDate else {
            return true
        }
        
        return Date() > expirationDate
    }
    
    func printRequestDetail(_ request: URLRequest) {
        guard Log.enable else { return }
        
        let method = request.httpMethod?.uppercased() ?? ""
        let urlString = request.url?.absoluteString ?? ""
        
        print("Request START ------------------------------------------------")
        print("\(method) - \(urlString)")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody {
            let text = String(data: body, encoding: .utf8) ?? ""
            print("Body: \(text)")
        }
        print("Request END --------------------------------------------------")
    }
    
    func printResponseDetail(data: Data?, response: URLResponse?, error: Error?) {
        guard Log.enable else { return }
        
        print("Response START ------------------------------------------------")
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else if let data = data, let response = response as? HTTPURLResponse {
            print("Status code: \(response.statusCode)")
            print("Headers: \(response.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
        }
        print("Response END --------------------------------------------------")
    }
    
}
