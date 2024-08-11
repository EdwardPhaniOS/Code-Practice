//
//  FeedItem.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

struct FeedItem {
    let id: String
    let desc: String?
    let location: String?
    let imageURL: URL?
    
    var toSaveObject: [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["description"] = desc
        dict["location"] = location
        dict["image_url"] = imageURL?.absoluteString ?? ""
        
        return dict
    }
}
