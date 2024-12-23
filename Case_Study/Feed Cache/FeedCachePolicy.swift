//
//  FeedCachePolicy.swift
//  Case_Study
//
//  Created by Vinh Phan on 12/08/2024.
//

import Foundation

struct FeedCachePolicy {
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        
        let maxCacheAgeInDays = 7
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp)
        else {
            return false
        }
        
        return date < maxCacheAge
    }
}





