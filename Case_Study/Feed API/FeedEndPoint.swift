//
//  FeedEndPoint.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

enum FeedEndPoint {
    case list
    
    var url: URL {
        switch self {
        case .list:
            return URL(string: Environment.baseURL + "/feed/list")!
        }
    }
}
