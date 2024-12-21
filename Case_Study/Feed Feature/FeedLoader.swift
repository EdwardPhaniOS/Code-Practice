//
//  FeedLoader.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (FeedLoader.Result) -> Void)
}
