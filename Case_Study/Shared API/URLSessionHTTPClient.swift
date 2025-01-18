//
//  URLSessionHTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    struct HTTPClientTaskWrapper: HTTPClientTask {
        let task: URLSessionTask?
        
        init(task: URLSessionTask?) {
            self.task = task
        }
        
        func cancel() {
            task?.cancel()
        }
    }
    
    struct UnexpectedError: Error {}
    
    @discardableResult
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return executeTask(request: request, completion: completion)
    }
    
    @discardableResult
    func delete(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return executeTask(request: request, completion: completion)
    }
    
    @discardableResult
    func post(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        return executeTask(request: request, completion: completion)
    }
    
    @discardableResult
    func put(to url: URL, data: Data?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        return executeTask(request: request, completion: completion)
    }
    
    @discardableResult
    func executeTask(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        printRequestDetail(request: request)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.printResponseDetail(data: data, response: response, error: error)
            
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data, let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(UnexpectedError()))
                }
            }
        }
        task.resume()
        
        return HTTPClientTaskWrapper(task: task)
    }
    
    func printRequestDetail(request: URLRequest) {
        guard Log.enable else { return }
        
        print("Request START ============================================")
        
        let method = request.httpMethod ?? ""
        let urlString = request.url?.absoluteString ?? ""
        print("Method: \(method.uppercased())")
        print("URL: \(urlString)")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers:")
            for (key, value) in headers {
                print("\(key): \(value)")
            }
            print("")
        }
        
        if let data = request.httpBody {
            let text = String(data: data, encoding: .utf8) ?? ""
            print("Body: - \(text)")
        }
        
        print("Request END ==============================================\n")
    }
    
    func printResponseDetail(data: Data?, response: URLResponse?, error: Error?) {
        guard Log.enable else { return }
        
        print("Response START ============================================")
        
        if let error = error {
            print("Error: \(error)")
        } else if let data = data, let response = response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            print("Headers:")
            for (key, value) in headers {
                print("\(key): \(value)")
            }
            print("")
            let statusCode = response.statusCode
            let responseString = String(data: data, encoding: .utf8) ?? ""
            print("Status Code: \(statusCode)")
            print("")
            print("Response: \(responseString)")
        } else {
            print("Error: Unknow error")
        }
        
        print("Response END ==============================================\n")
    }
        
}

