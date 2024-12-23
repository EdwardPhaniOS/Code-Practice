//
//  HTTPClient.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func delete(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func post(to url: URL, data: Data?, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func put(to url: URL, data: Data?, completion: @escaping (Result) -> Void) -> HTTPClientTask
}

