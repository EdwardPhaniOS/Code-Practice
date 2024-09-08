//
//  URLSessionHTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 08/09/2024.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        //Adapter pattern
        let dataTask: URLSessionDataTask
        
        init(dataTask: URLSessionDataTask) {
            self.dataTask = dataTask
        }
        
        func cancel() {
            dataTask.cancel()
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
    
    func executeRequest(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        printRequestDetail(request)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
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
    
    func printRequestDetail(_ request: URLRequest) {
        guard Log.enable else { return }
        
        let method = request.httpMethod?.uppercased() ?? ""
        let urlString = request.url?.absoluteString ?? ""
        
        print("Request START ==================================================")
        print("\(method) - \(urlString)")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody {
            let text = String(data: body, encoding: .utf8) ?? ""
            print("Body: \(text)")
        }
        print("Request END ==================================================")
    }
    
    func printResponseDetail(data: Data?, response: URLResponse?, error: Error?) {
        guard Log.enable else { return }
        
        print("Response START ==================================================")
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else if let data = data, let response = response as? HTTPURLResponse {
            print("Status code: \(response.statusCode)")
            print("Headers: \(response.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
        }
        print("Response END ==================================================")
    }
    
}
