//
//  EventData.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 01/02/2023.
//

import Foundation

class EventData {
    var id: String
    var key: String
    var time: Int
    var sessionId: String
    var realtime: Bool
    var data = [DataInfo]()
    
    init(id: String, key: String, time: Int, sessionId: String, realtime: Bool, data: [DataInfo]) {
        self.id = id
        self.key = key
        self.time = time
        self.sessionId = sessionId
        self.realtime = realtime
        self.data = data
    }
    
    static func makeEvent(key: String, sessionId: String, realtime: Bool, data: [String: Any]?) -> EventData {
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        let randomNumber = Int.random(in: 0..<Int.max)
        let hexTimestamp = String(timestamp, radix: 16)
        let hexRandomNumber = String(randomNumber, radix: 16)
        let uniqueID = hexTimestamp + hexRandomNumber
        let filteredID = uniqueID.filter { "0123456789abcdefABCDEF".contains($0) }
        
        let event = EventData(id: filteredID, key: key, time: Int(timestamp/1000), sessionId: sessionId, realtime: realtime, data: [])
        data?.forEach { key, value in
            event.setData(key: key, value: value)
        }
        return event
    }
    
    func setData(key: String, value: Any) {
        data.append(DataInfo(key: key, value: value))
    }
    
    struct DataInfo {
        var key: String
        var value: Any
    }
    
    public static func convertToArray(_ events: [EventData]) -> [[String: Any]] {
        var eventsDictionary = [[String: Any]]()
        
        for event in events {
            eventsDictionary.append(convertToDictionary(event))
        }
        return eventsDictionary
    }
    
    public static func convertToDictionary(_ event: EventData) -> [String: Any] {
        var data = [[String: Any]]()
        for dataInfo in event.data {
            data.append(["key": dataInfo.key, "value": dataInfo.value])
        }
        return ["id": event.id, "key": event.key, "time": event.time, "sessionId": event.sessionId, "realtime": event.realtime, "data": data]
    }
}

