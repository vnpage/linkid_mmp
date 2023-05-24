//
//  EventData.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 01/02/2023.
//

import Foundation
import GRDB

class EventData: Codable, FetchableRecord, PersistableRecord {
    var id: String
    var key: String
    var time: Int
    var sessionId: String
    var realtime: Bool
    var data: String = "{}"
    
    init(id: String, key: String, time: Int, sessionId: String, realtime: Bool, data: String?) {
        self.id = id
        self.key = key
        self.time = time
        self.sessionId = sessionId
        self.realtime = realtime
        self.data = data ?? "{}"
    }
    
    static func makeEvent(key: String, sessionId: String, realtime: Bool, data: [String: Any]?) -> EventData {
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        let randomNumber = Int.random(in: 0..<Int.max)
        let hexTimestamp = String(timestamp, radix: 16)
        let hexRandomNumber = String(randomNumber, radix: 16)
        let uniqueID = hexTimestamp + hexRandomNumber
        let filteredID = uniqueID.filter { "0123456789abcdefABCDEF".contains($0) }
        
        let event = EventData(id: filteredID, key: key, time: Int(timestamp/1000), sessionId: sessionId, realtime: realtime, data: EventData.toJsonString(dictionary: data))
        return event
    }
    
    public static func convertToArray(_ events: [EventData]) -> [[String: Any]] {
        var eventsDictionary = [[String: Any]]()
        
        for event in events {
            eventsDictionary.append(convertToDictionary(event))
        }
        return eventsDictionary
    }
    
    public func getSessionId() -> String {
        var s = sessionId
        if s == "" {
            s = StorageHelper.shared.getAuthData()?.data?.sessionId ?? ""
        }
        return s
    }
    
    public static func convertToDictionary(_ event: EventData) -> [String: Any] {
        var data = [[String: Any]]()
        let eventData = EventData.jsonStringToDict(jsonString: event.data)
        eventData?.forEach({ (key: String, value: Any) in
            data.append(["key": key, "value": value])
        })
        return ["id": event.id, "key": event.key, "time": event.time, "sessionId": event.getSessionId(), "realtime": event.realtime, "data": data]
    }
    
    public static func toJsonString(dictionary: [String: Any]?) -> String {
        do {
            if dictionary != nil && (dictionary?.count ?? 0)>0 {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionary ?? [], options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            }
        } catch {
            print("Error converting dictionary to JSON string: \(error)")
        }
        return "{}"
    }
    
    public static func jsonStringToDict(jsonString: String) -> [String: Any]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting JSON string to dictionary: \(error)")
        }
        
        return nil
    }
    
    public static func convertToDictionary2(_ event: EventData) -> [String: Any] {
        return ["id": event.id, "key": event.key, "time": event.time, "sessionId": event.getSessionId(), "realtime": event.realtime, "data": event.data]
    }
    
    public static func fromDictionary2(_ data: [String: Any]) -> EventData? {
        if let key = data["key"] as? String, let id = data["id"] as? String, let time = data["time"] as? Int, let realtime = data["realtime"] as? Bool  {
            let sessionId = (data["sessionId"] as? String) ?? ""
            let jsonString = (data["data"] as? String) ?? "{}"
            let event = EventData.init(id: id, key: key, time: time, sessionId: sessionId, realtime: realtime, data: jsonString)
            return event
        }
        return nil
    }
}

