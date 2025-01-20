//
//  DictionaryExtension.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 23/02/2023.
//

import Foundation

extension Dictionary {
    
//    static func +=(lhs: inout Self, rhs: Self) {
//        lhs.merge(rhs) { _ , new in new }
//    }
//    
//    static func +=<S: Sequence>(lhs: inout Self, rhs: S) where S.Element == (Key, Value) {
//        lhs.merge(rhs) { _ , new in new }
//    }
//    
//    func mergedWith(otherDictionary: [Key: Value]) -> [Key: Value] {
//        var mergedDict: [Key: Value] = [:]
//        [self, otherDictionary].forEach { dict in
//            for (key, value) in dict {
//                mergedDict[key] = value
//            }
//        }
//        return mergedDict
//    }
    mutating func merged(with other: Dictionary) {
        self.merge(other, uniquingKeysWith: { _, new in new })
    }
    
    var jsonData: Data? {
       return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
    func toJSONString() -> String? {
       if let jsonData = jsonData {
          let jsonString = String(data: jsonData, encoding: .utf8)
          return jsonString
       }
       return nil
    }
}
