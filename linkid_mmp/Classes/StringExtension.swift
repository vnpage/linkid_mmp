//
//  StringExtension.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation

extension String {
    
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func endWiths(_ str: String) -> Bool {
         return self.suffix(str.count) == str
    }
    
    func startWiths(_ str: String) -> Bool {
        return self.prefix(str.count) == str
    }
}
