//
//  TrackingEvent.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 03/01/2023.
//

import Foundation
import SQLite

class TrackingEvent {
    private static let syncInterval: TimeInterval = 10 // sync every 5 seconds
    private static let syncEventCount = 10 // sync after every 10 events
    private static var eventQueue: [EventData] = [] // queue to store events that are waiting to be synced
    private static var syncTimer: Timer? // timer to schedule syncs at regular intervals
    private static let semaphore = DispatchSemaphore(value: 1) // semaphore to limit the number of concurrent syncs
    private static var lastEventTime: Date? // last event time
    private static var eventTotalCounter = 0;
    private static var isSyncing = false;
    
    private static var db: Connection?
    private static var authData: AuthData?
    
    class func initDb() {
        do {
            if(TrackingEvent.db==nil) {
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                ).first!
                TrackingEvent.db = try Connection("\(path)/linkid_mmp.sqlite3")
                let events = Table("events")
                let name = Expression<String>("name")
                let data = Expression<String>("data")
                
                try! db?.run(events.create(ifNotExists: true) { t in
                    t.column(name)
                    t.column(data)
                })
            }
        } catch {
            // handle the error
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    
    class func checkAuth() {
        authData = StorageHelper.shared.getAuthData()
    }

    class func trackEvent(name: String, data: [String: Any]?) {
        print("tracking event: \(name)")
        initDb()
        checkAuth()
        
        eventQueue.append(EventData.makeEvent(key: name, sessionId: authData?.data.sessionId ?? "", realtime: false, data: data))
        eventTotalCounter += 1
        lastEventTime = Date()

        if syncTimer == nil {
            startSyncTimer()
        }

        // check if it's time to sync
        if eventQueue.count >= syncEventCount {
            sync()
        }
    }
    
    class func getTotalCount() -> Int {
        return eventTotalCounter
    }

    private class func sync() {
        // send the queued events to the server
        // you can use a library like Alamofire to make the HTTP request
        // alternatively, you can use a third-party service like Mixpanel or Amplitude to track the events
        if(isSyncing==true) {
            return
        }
        stopSyncTimer()
        isSyncing = true
        print("----- syncing -----")
        
        var _data: [EventData] = []
        if eventQueue.count > syncEventCount {
            _data += eventQueue.prefix(syncEventCount)
            eventQueue = eventQueue.suffix(eventQueue.count-syncEventCount)
        } else {
            lastEventTime = nil
            _data += eventQueue
            eventQueue.removeAll()
        }
        
        HttpClient.shared.post(with: "http://178.128.221.107:3001/partner/event/log", params: ["events": EventData.convertToArray(_data)]) { data, error in
            isSyncing = false
            if let data = data {
                // handle received data
                print("----- sync successful -----")
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                    // handle response string
                } else {
                    // handle error converting data to string
                }
            } else {
                print("----- sync error -----")
                print(error)
                eventQueue += _data
            }
            if eventQueue.count>0 {
                startSyncTimer()
            }
        }
    }

    private class func startSyncTimer() {
        syncTimer = Timer.scheduledTimer(withTimeInterval: syncInterval, repeats: true) { _ in
            if let lastEventTime = lastEventTime {
                print("lastEventTime \(lastEventTime)")
                print("eventQueue.count \(eventQueue.count)")
                if Date().timeIntervalSince(lastEventTime) >= syncInterval && eventQueue.count>0 {
                    print("time to sync")
                    sync()
                }
            }
        }
    }
    
    private class func stopSyncTimer() { 
        syncTimer?.invalidate()
        syncTimer = nil
    }
}

extension Dictionary {
    func mergedWith(otherDictionary: [Key: Value]) -> [Key: Value] {
        var mergedDict: [Key: Value] = [:]
        [self, otherDictionary].forEach { dict in
            for (key, value) in dict {
                mergedDict[key] = value
            }
        }
        return mergedDict
    }
}

