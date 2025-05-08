//
//  StyleParser.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import Foundation

class StyleParser {
    static func parseStyle(_ styleString: String?) -> [String: String] {
        print("StyleParser: Parsing style: \(styleString ?? "nil")")
        var styles: [String: String] = [:]
        
        guard let styleString = styleString, !styleString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return styles
        }
        
        let declarations = styleString.split(separator: ";")
        for declaration in declarations {
            let pair = declaration.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            if pair.count == 2 {
                styles[pair[0]] = pair[1]
                print("StyleParser: Parsed style: \(pair[0]) = \(pair[1])")
            }
        }
        
        return styles
    }
}
