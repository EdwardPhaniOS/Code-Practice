//
//  Log.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

struct Log {
    static var enableLog: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static func log(_ item: Any, file: String = #file, function: String = #function, line: Int = #line) {
        if Log.enableLog {
            let fileName = file.components(separatedBy: "/").last ?? ""
            print("➡️ [\(fileName)] - function: \(function) - line: \(line) - item: \(item)")
        }
    }
    
    static func error(_ error: String, file: String = #file, function: String = #function, line: Int = #line) {
        if Log.enableLog {
            let fileName = file.components(separatedBy: "/").last ?? ""
            print("➡️ [\(fileName)] - function: \(function) - line: \(line) - error: \(error)")
        }
    }
}
