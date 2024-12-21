//
//  Log.swift
//  Case_Study
//
//  Created by Vinh Phan on 11/08/2024.
//

import Foundation

struct Log {
    static var enable: Bool {
        #if Release
        return false
        #else
        return true
        #endif
    }
    
    static func log(_ item: Any, file: String = #file, function: String = #function, line: UInt = #line) {
        if Log.enable {
            let fileName = file.components(separatedBy: "/").last ?? ""
            print("➡️ [\(fileName)] - function: \(function) - line: \(line) - item: \(item)")
        }
    }
    
    static func error(_ error: String, file: String = #file, function: String = #function, line: UInt = #line) {
        if Log.enable {
            let fileName = file.components(separatedBy: "/").last ?? ""
            print("➡️ [\(fileName)] - function: \(function) - line: \(line) - error: \(error)")
        }
    }
}



