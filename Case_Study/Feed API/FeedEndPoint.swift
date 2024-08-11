//
//  FeedEndPoint.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

enum FeedEndPoint {
    case list
    case detail(String)
    case save
    
    var url: URL {
        let baseURL = Environment.baseURL
        var urlString = ""
        
        switch self {
        case .list:
            urlString = baseURL + "feed/list"
        case let .detail(id):
            urlString = baseURL + "fedd/\(id)"
        case .save:
            urlString = baseURL + "feed/save"
        }
        
        return URL(string: urlString)!
    }
}
