//
//  AuthHTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 21/12/24.
//

import Foundation

class AuthHTTPClient: URLSessionHTTPClient {
    
    @discardableResult
    override func executeTask(request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPClientTask {
        
        var updatedRequest = request
        
        if AuthManager.shared.hasValidToken() {
            let token = AuthManager.shared.getAccessToken()
            updatedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return super.executeTask(request: updatedRequest, completion: completion)
            
        } else {
            AuthManager.shared.ensureValidAccessToken { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    executeTask(request: updatedRequest, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
            return HTTPClientTaskWrapper(task: nil)
        }
    }
}
