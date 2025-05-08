//
//  AdItem.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 18/4/25.
//

import Foundation

public class AdItem: CustomStringConvertible {
    var adData: [String]
    var size: AdSize

    init(adData: [String], size: AdSize) {
        self.adData = adData
        self.size = size
    }

    public var description: String {
        return "AdItem(adData: \(adData), size: \(size))"
    }

    public func toJsonObject() -> [String: Any] {
        var jsonObject: [String: Any] = [:]
        jsonObject["adData"] = adData
        jsonObject["size"] = size.toJsonObject()
        return jsonObject
    }

    public func toJsonString() -> String? {
        let jsonObject = toJsonObject()
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }

    public class AdSize: CustomStringConvertible {
        var width: Int
        var height: Int

        init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }

        public var description: String {
            return "AdSize(width: \(width), height: \(height))"
        }

        public func toJsonObject() -> [String: Any] {
            return ["width": width, "height": height]
        }
    }
}
