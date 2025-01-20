//
//  FlagHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 21/10/24.
//

import Foundation

public class FlagData {
    public var success: Bool = false
    public var message: String = ""
    public var total: Int64 = 0
    var data: [String: Any] = [:]
    
    init(success: Bool, message: String, total: Int64, data: [String : Any]) {
        self.success = success
        self.message = message
        self.data = data
        self.total = total
    }
    
    public func getFlag(flagKey: String) -> Any? {
        return data[flagKey]
    }
    
    public func getFlags() -> [String: Any] {
        return data
    }
    
    public var count: Int {
        return data.count
    }
    
    public func toString() -> String {
        return "FlagData(success: \(success), message: \(message), data: \(data))"
    }
}

class FlagHelper {
    public static func setFlag(flagKey: String, flagValue: String, description: String, source: String, completion: @escaping (FlagData) -> Void) {
        let parameters: [String: String] = [
            "flag_key": flagKey,
            "flag_value": flagValue,
            "description": description,
            "created_by_source": source
        ]
        HttpClient.shared.post(with: "/partner/flag-config/create-flag", params: parameters) { data, error in
            if data != nil {
                let flagData = FlagData(success: true, message: "", total: 0, data: [:])
                completion(flagData)
            } else {
                if let error {
                    completion(FlagData(success: false, message: error.localizedDescription, total:0, data: [:]))
                } else {
                    completion(FlagData(success: false, message: "Can't connect to server", total:0, data: [:]))
                }
            }
        }
    }
    
    public static func getFlags(flagKey: String, limit: Int, offset: Int, completion: @escaping (FlagData) -> Void) {
        let parameters: [String: String] = [
            "flag_key": flagKey,
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]
        HttpClient.shared.get(with: "/partner/flag-config/search-flags", params: parameters) { data, error in
            if data != nil {
                do {
                    if let jsonDict: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if let _data = jsonDict["data"] as? [String: Any] {
                            if let items = _data["items"] as? [[String: Any]], let total = _data["totalRecords"] as? Int64 {
                                var datas: [String: Any] = [:]
                                for (_, item) in items.enumerated() {
                                    Logger.log(item)
                                    if let key = item["flag_key"] as? String, let value = item["flag_value"] {
                                        datas[key] = value
                                    }
                                }
                                let flagData = FlagData(success: true, message: "Success", total: total, data: datas)
                                completion(flagData)
                            } else {
                                let flagData = FlagData(success: true, message: "No data", total: 0, data: [:])
                                completion(flagData)
                            }
                        } else {
                            let flagData = FlagData(success: true, message: "No data", total: 0, data: [:])
                            completion(flagData)
                        }
                    } else {
                        let flagData = FlagData(success: true, message: "Can't parse data", total: 0, data: [:])
                        Logger.log("Can't parse data")
                        completion(flagData)
                    }
                    
                } catch {
                    let flagData = FlagData(success: true, message: "Can't parse data", total: 0, data: [:])
                    Logger.log(error)
                    completion(flagData)
                }
            } else {
                if let error {
                    completion(FlagData(success: false, message: error.localizedDescription, total: 0, data: [:]))
                } else {
                    completion(FlagData(success: false, message: "Can't connect to server", total: 0, data: [:]))
                }
            }
        }
    }
    
    public static func getFlags(limit: Int, offset: Int, completion: @escaping (FlagData) -> Void) {
        let parameters: [String: String] = [
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]
        HttpClient.shared.get(with: "/partner/flag-config/get-flags", params: parameters) { data, error in
            if data != nil {
                do {
                    if let jsonDict: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if let _data = jsonDict["data"] as? [String: Any] {
                            if let items = _data["items"] as? [[String: Any]], let total = _data["totalRecords"] as? Int64 {
                                var datas: [String: Any] = [:]
                                for (_, item) in items.enumerated() {
                                    Logger.log(item)
                                    if let key = item["flag_key"] as? String, let value = item["flag_value"] {
                                        datas[key] = value
                                    }
                                }
                                let flagData = FlagData(success: true, message: "Success", total: total, data: datas)
                                completion(flagData)
                            } else {
                                let flagData = FlagData(success: true, message: "No data", total: 0, data: [:])
                                completion(flagData)
                            }
                        } else {
                            let flagData = FlagData(success: true, message: "No data", total: 0, data: [:])
                            completion(flagData)
                        }
                    } else {
                        let flagData = FlagData(success: true, message: "Can't parse data", total: 0, data: [:])
                        Logger.log("Can't parse data")
                        completion(flagData)
                    }
                    
                } catch {
                    let flagData = FlagData(success: true, message: "Can't parse data", total: 0, data: [:])
                    Logger.log(error)
                    completion(flagData)
                }
            } else {
                if let error {
                    completion(FlagData(success: false, message: error.localizedDescription, total: 0, data: [:]))
                } else {
                    completion(FlagData(success: false, message: "Can't connect to server", total: 0, data: [:]))
                }
            }
        }
    }
}
