//
//  HTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
    
    func post(to url: URL, data: Data?, completion: @escaping (Result) -> Void)
    
    func put(to url: URL, data: Data?, completion: @escaping (Result) -> Void)
    
    func delete(from url: URL, completion: @escaping (Result) -> Void)
}
