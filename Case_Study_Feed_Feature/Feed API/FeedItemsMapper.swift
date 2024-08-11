//
//  FeedItemsMapper.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

class FeedItemsMapper {
    
    private struct Root: Decodable {
        private var items: [RemoteItem]
        
        private struct RemoteItem: Decodable {
            let id: String
            let desc: String?
            let location: String?
            let image: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case desc = "description"
                case location
                case image = "image_url"
            }
        }
        
        var feedItems: [FeedItem] {
            return items.map {
                FeedItem(id: $0.id, desc: $0.desc, location: $0.location, imageURL: URL(string: $0.image))
            }
        }
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200, 
                let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw Error.invalidData
        }
        
        return root.feedItems
    }
    
}
