//
//  Environment.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

enum Environment {
    case development
    case testing
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #elseif QA
        return .testing
        #else
        return .production
        #endif
    }
    
    static var baseURL: String {
        switch current {
        case .development:
            return "https://dev.apis.com"
        case .testing:
            return "https://test.apis.com"
        case .production:
            return "https://prod.apis.com"
        }
    }
    
}

