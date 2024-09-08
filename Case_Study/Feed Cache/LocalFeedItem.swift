//
//  LocalFeedItem.swift
//  Case_Study
//
//  Created by Vinh Phan on 15/08/2024.
//

import Foundation

struct LocalFeedItem {
    let id: String
    let desc: String?
    let location: String?
    let imageUrl: String
    
    init(id: String, desc: String?, location: String?, imageUrl: String) {
        self.id = id
        self.desc = desc
        self.location = location
        self.imageUrl = imageUrl
    }
}
