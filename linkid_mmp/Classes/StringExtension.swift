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
                Logger.log(error.localizedDescription)
            }
        }
        return nil
    }
    
//    func endWiths(_ str: String) -> Bool {
//         return self.suffix(str.count) == str
//    }
//    
//    func startWiths(_ str: String) -> Bool {
//        return self.prefix(str.count) == str
//    }
    
    
    func startWith(_ prefix: String) -> Bool {
        return self.hasPrefix(prefix)
    }

    func endWith(_ suffix: String) -> Bool {
        return self.hasSuffix(suffix)
    }
    
    func replaceAlls(of pattern: String, with replacement: String, options: NSRegularExpression.Options = []) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        } catch {
            return self
        }
    }
    
    init?(hex: String) {
        var hex = hex
        var data = Data()
        while !hex.isEmpty {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let subString = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            guard let byte = UInt8(subString, radix: 16) else {
                return nil
            }
            data.append(byte)
        }
        self.init(data: data, encoding: .utf8)
    }
}
