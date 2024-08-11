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
        printRequestDetail(request)
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                Log.error(error.localizedDescription)
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                self.printResponseDetail(data: data, response: response)
                completion(.success((data, response)))
            }
        }.resume()
    }
    
    private func printRequestDetail(_ request: URLRequest) {
        if !Log.enableLog { return }
        
        print("\n------------------------------------------------------------")
        if let url = request.url {
            print("Request url: \(url.absoluteString)")
        }
        if let method = request.httpMethod {
            print("HTTP Method: \(method)")
        }
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
            let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)\n")
        }
        print("------------------------------------------------------------\n")
    }
    
    private func printResponseDetail(data: Data, response: HTTPURLResponse) {
        if !Log.enableLog { return }
        
        print("\n------------------------------------------------------------")
        print("Response URL: \(response.url?.absoluteString ?? "No URL")")
        print("Status Code: \(response.statusCode)")
        if let bodyString = String(data: data, encoding: .utf8) {
            print("Response Body: \(bodyString)")
        }
        print("------------------------------------------------------------\n")
    }
    
}






