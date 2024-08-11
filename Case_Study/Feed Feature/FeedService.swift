//
//  FeedLoader.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

protocol FeedService {
    func load(completion: @escaping (Swift.Result<[FeedItem], Error>) -> Void)
    func save(item: FeedItem, completion: @escaping (Swift.Result<Void, Error>) -> Void)
}
