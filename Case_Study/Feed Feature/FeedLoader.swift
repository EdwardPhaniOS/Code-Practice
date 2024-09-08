//
//  FeedLoader.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

protocol FeedLoader {
    func load(completion: @escaping (Swift.Result<[FeedItem], Error>) -> Void)
}
