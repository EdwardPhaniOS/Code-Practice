//
//  FeedItemsMapper.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

class FeedItemsMapper {
    struct Root: Decodable {
        var items: [RemoteItem]
        
        struct RemoteItem: Decodable {
            let id: UUID
            let desc: String?
            let location: String?
            let image: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case desc = "description"
                case location
                case image
            }
        }
        
        var feedImages: [FeedImage] {
            items.map { FeedImage(id: $0.id, description: $0.desc, location: $0.location, url: URL(string: $0.image ?? "")!) }
        }
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.statusCode == 200,
                let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw NSError(domain: "Invalid data", code: 0)
        }
        
        return root.feedImages
    }
}
