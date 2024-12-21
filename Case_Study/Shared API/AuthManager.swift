//
//  AuthManager.swift
//  Case_Study
//
//  Created by Vinh Phan on 21/12/24.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    private(set) var accessToken: String = ""
    private(set) var refreshToken: String = ""
    private(set) var expiredData: Date?
    
    private var isRefreshingToken: Bool = false
    
    private var pendingRequest: [(Swift.Result<String, Error>) -> Void] = []
    
    private init() {}
    
    func setTokens(accessToken: String, refreshToken: String, expiredData: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiredData = expiredData
    }
    
    func getAccessToken() -> String {
        return accessToken
    }
    
    func clearTokens() {
        accessToken = ""
        refreshToken = ""
        expiredData = nil
    }
    
    func isTokenExpired() -> Bool {
        guard let date = expiredData else { return false }
        return Date() > date
    }
    
    func refreshAccessToken(completion: @escaping (Swift.Result<String, Error>) -> Void) {
        if isRefreshingToken {
            pendingRequest.append(completion)
            return
        }
        
        isRefreshingToken = true
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            let newAccessToken = "new_access_token"
            let newRefreshToken = "new_refresh_token"
            let newExpirationDate = Date().addingTimeInterval(3600) //1 hour expiration
            
            setTokens(accessToken: newAccessToken, refreshToken: newRefreshToken, expiredData: newExpirationDate)
            
            self.pendingRequest.forEach { $0(.success(newAccessToken)) }
            self.pendingRequest.removeAll()
            
            completion(.success(newAccessToken))
            
            self.isRefreshingToken = false
        }
    }
    
    func hasValidToken() -> Bool {
        return !isTokenExpired() && !accessToken.isEmpty
    }
    
    func ensureValidAccessToken(completion: @escaping (Swift.Result<String, Error>) -> Void) {
        
        if isTokenExpired() {
            refreshAccessToken { result in
                switch result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let error):
                    self.handleLogout()
                    completion(.failure(error))
                }
            }
        } else if !accessToken.isEmpty {
            completion(.success(accessToken))
        } else {
            handleLogout()
            completion(.failure(NSError(domain: "No access token", code: 401)))
        }
    }
    
    func handleLogout() {
        clearTokens()
        
        DispatchQueue.main.async {
            //TODO: Get root view controller then present Login Page
        }
    }
}
